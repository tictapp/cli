#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import "https://deno.land/std@0.177.0/dotenv/load.ts";
import deploy from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

export default async function _deploy(args) {

    const functionName = args._.shift()

    const TOKEN = Deno.env.get('TOKEN')

    let PROJECT_REF = args.project || Deno.env.get('PROJECT_REF')

    if (!PROJECT_REF) {
        const studio_api = StudioAPI.fromToken(TOKEN)
        const studio_projects = await studio_api.requestJson(`/projects`)
        if (studio_projects.error) {
            console.log(studio_projects)
            Deno.exit()
        }
        console.table(studio_projects.map(o => ({ name: o.name, ref: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })))

        PROJECT_REF = prompt(`Enter project ref`)
    }

    const FUNCTIONS_DOMAIN = Deno.env.get("FUNCTIONS_DOMAIN")

    const DENO_DEPLOY_TOKEN = Deno.env.get("DENO_DEPLOY_TOKEN")
    const DENO_DEPLOY_ORG = Deno.env.get("DENO_DEPLOY_ORG")

    const DENO_DEPLOY_PROJECT = `${PROJECT_REF}-${functionName}`

    const studioAPI = StudioAPI.fromToken(TOKEN)
    const project = await studioAPI.requestJson(`/projects/${PROJECT_REF}?_data`)

    if (project.error) {
        console.log(project)
        Deno.exit()
    }

    const denoAPI = DenoAPI.fromToken(DENO_DEPLOY_TOKEN);
    const denoProject = await denoAPI.getProject(DENO_DEPLOY_PROJECT);

    const defaultEnvVars = {
        "SUPABASE_REF": project.ref,
        "SUPABASE_URL": `https://${project.endpoint}`,
        "SUPABASE_ANON_KEY": project.anon_key,
        "SUPABASE_SERVICE_KEY": project.service_key,
        "JWT_SECRET": project.jwt_secret,
        "VERIFY_JWT": String(args['verify-jwt']),
    }

    await Deno.writeTextFile(`.env.defaults`, stringify(defaultEnvVars));

    const envVars = await load({
        envPath: `functions/${functionName}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });

    envVars['FUNCTION_URL'] = `https://${PROJECT_REF}.${FUNCTIONS_DOMAIN}/${functionName}`

    if (denoProject === null) {
        const res = await denoAPI.requestJson('/projects', {
            method: 'POST',
            body: {
                "name": DENO_DEPLOY_PROJECT,
                "organizationId": DENO_DEPLOY_ORG,
                "envVars": envVars
            }
        })

        console.log('new func --> ', res)

    } else {

        // const lines = Object.keys(defaultEnvVars).map(key => {
        //     return `${key}=${defaultEnvVars[key]}`
        // }).join("\n")

        await denoAPI.requestJson(`/projects/${denoProject.id}/env`, {
            method: 'PATCH',
            body: envVars
        })

        console.log('exists', 'hasProductionDeployment =>', denoProject.hasProductionDeployment)
    }

    async function exists(path) {
        try {
            return (await Deno.stat(path)).isFile;
        } catch {
            return false;
        }
    }

    let entrypoint = `./functions/${functionName}/index.js`
    if (!(await exists(entrypoint)))
        entrypoint = `./functions/${functionName}/index.ts`

    if (!(await exists(entrypoint)))
        entrypoint = `./functions/${functionName}/main.ts`
    if (!(await exists(entrypoint)))
        entrypoint = `./functions/${functionName}/main.js`

    if (!(await exists(entrypoint))) {
        console.error(`Entrypoint failed: ${entrypoint}`)
        Deno.exit()
    }

    await deploy({
        token: DENO_DEPLOY_TOKEN,
        project: DENO_DEPLOY_PROJECT,
        prod: args.prod,
        static: args.static,
        "import-map": args["import-map"] && `./functions/${functionName}/${args["import-map"]}`,
        //include: `functions`,
        _: [entrypoint]
    })

    console.log(`

Endpoint:%c
    https://${PROJECT_REF}.${FUNCTIONS_DOMAIN}/${functionName}
    https://${PROJECT_REF}-${functionName}.${FUNCTIONS_DOMAIN}

%c${stringify(envVars)}`, 'color: lime', 'background-color: #222;color:#999')

}