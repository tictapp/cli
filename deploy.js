import "https://deno.land/std@0.177.0/dotenv/load.ts";
import deploy from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { exists, getJson } from "./helpers.js";
import { Select } from "https://deno.land/x/cliffy@v0.25.7/prompt/select.ts";
import { colors } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";

// psql \
//   --single-transaction \
//   --variable ON_ERROR_STOP=1 \
//   --file dump-fapp.sql \
//   --dbname "$NEW_DB_URL"

export default async function _deploy(args) {

    let functionName = args._.shift()
    let funPath = `./functions/${functionName}`

    if (!functionName) {
        funPath = Deno.cwd()
        functionName = funPath.split("/").pop()

        Deno.chdir('../../')

        if (await exists('./tictapp.json')) {
            const { project } = await getJson(`./tictapp.json`)
            if (project) {
                Deno.env.set('PROJECT_REF', project.ref)
            }
        }

        console.log(colors.red(`Function Auto`), { funPath, functionName, cwd: Deno.cwd() })
        //Deno.exit()
    }

    const TOKEN = Deno.env.get('TOKEN')

    let PROJECT_REF = args.project || Deno.env.get('PROJECT_REF')

    if (!PROJECT_REF || PROJECT_REF === true) {
        const studio_api = StudioAPI.fromToken(TOKEN)
        const studio_projects = await studio_api.requestJson(`/projects`)
        if (studio_projects.error) {
            console.log(studio_projects)
            Deno.exit()
        }
        // console.table(studio_projects.map(o => ({ name: o.name, ref: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })))

        // PROJECT_REF = prompt(`Enter project ref`)
        PROJECT_REF = await Select.prompt({
            message: "Pick a project",
            options: studio_projects.map(o => ({ name: `${o.ref} - ${o.name}`, value: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })),
        });
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

    if (args.seed) {
        // psql \
        //   --single-transaction \
        //   --variable ON_ERROR_STOP=1 \
        //   --file dump-fapp.sql \
        //   --dbname "$NEW_DB_URL"
        const process = Deno.run({
            cmd: [
                "psql",
                "--single-transaction",
                "--variable",
                "ON_ERROR_STOP=1",
                "--file",
                `${funPath}/seed.sql`,
                "--dbname",
                `postgresql://supabase_admin:${project.db_pass}@db.tictapp.io:${project.db_port}/postgres`
            ],
        });
        await process.status();
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

    envVars['FUNCTION_NAME'] = functionName

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


    if (!args.root) {
        Deno.chdir(funPath)

        funPath = '.'
    }

    let entrypoint = `${funPath}/index.js`
    if (!(await exists(entrypoint)))
        entrypoint = `${funPath}/index.ts`

    if (!(await exists(entrypoint)))
        entrypoint = `${funPath}/main.ts`
    if (!(await exists(entrypoint)))
        entrypoint = `${funPath}/main.js`

    if (!(await exists(entrypoint))) {
        console.error(`Entrypoint failed: ${entrypoint}`)
        Deno.exit()
    }

    const deployArgs = {
        token: DENO_DEPLOY_TOKEN,
        project: DENO_DEPLOY_PROJECT,
        prod: args.prod,
        static: args.static,
        //include: functionName,
        _: [entrypoint]
    }

    if (await exists(`${funPath}/import_map.json`))
        deployArgs["import-map"] = `${funPath}/import_map.json`

    await deploy(deployArgs)

    const _fun = await studioAPI.requestJson(`/admin/projects/${PROJECT_REF}/functions`, {
        method: 'POST',
        body: {
            name: functionName,
            verify_jwt: args["verify-jwt"],
            import_map: args["import-map"],
            envVars
        }
    })

    const subdomain = project.endpoint.replace('.tictapp.io', "")

    console.log(`

Path
    
    ${Deno.cwd()}

Endpoints (v${_fun.version})

    https://${subdomain}.${FUNCTIONS_DOMAIN}/${functionName}
    https://${subdomain}-${functionName}.${FUNCTIONS_DOMAIN}
    https://${subdomain}.functions.tictapp.io/${functionName}

Logs Stream

    https://${subdomain}-${functionName}.${FUNCTIONS_DOMAIN}/.logs

Environment Variables

    https://${subdomain}-${functionName}.${FUNCTIONS_DOMAIN}/.env
`)

    //console.log('_fun', _fun)

}