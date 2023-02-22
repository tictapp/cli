#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import { API as StudioAPI } from "./api_studio.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { getJson, writeJson, exists } from "./helpers.js";

export default async function _init(args) {

    const configFile = `./tictapp.json`
    let config = {}

    if ((await exists(configFile)))
        config = await getJson(configFile)


    try {
        const token = prompt(`

Enter your access token 
Generate one at https://tictapp.studio/account/tokens
(token) =`, config.token);

        const api = StudioAPI.fromToken(token)
        const profile = await api.requestJson(`/profile`)

        if (profile.error) {
            console.error(`
    Error ${profile.error.status} ${profile.error.name}
    ${profile.error.message}
    
    bye ;)

    `)

            Deno.exit()
        }

        config.token = token
        config.profile = profile

        await writeJson(configFile, config)

        const projects = await api.requestJson(`/projects`)

        const projectsList = projects.map(p => {
            return {
                name: p.name,
                ref: p.ref,
                //endpoint: p.endpoint,
                status: p.status,
                created: p.inserted_at
            }
        })

        //console.log('init', { token, profile, projects })

        console.table(projectsList)

        const project_ref = prompt(`
Set your project ref
(project.ref) =`, config.project?.ref)

        const project = await api.requestJson(`/projects/${project_ref}?_data`)

        if (project.error) {
            console.error(`
    Api Error (/projects/${project_ref}) 
    ${project.error.status || project.error.code} ${project.error.name}
    ${project.error.message}
    
    bye ;)

    `)
            Deno.exit()
        }

        config.project = { ...project, auth_config: {} }

        await writeJson(configFile, config)

        const deno_deploy_token = prompt(`Deno deploy token:`, config.deno_deploy_token)
        config.deno_deploy_token = deno_deploy_token

        await writeJson(configFile, config)

        const deno_deploy_org = prompt(`Deno deploy organization id:`, config.deno_deploy_org)
        config.deno_deploy_org = deno_deploy_org

        await writeJson(configFile, config)

        const defaultEnvVars = {
            "SUPABASE_REF": project.ref,
            "SUPABASE_URL": `https://${project.endpoint}`,
            "SUPABASE_ANON_KEY": project.anon_key,
            "SUPABASE_SERVICE_KEY": project.service_key,
            "JWT_SECRET": project.jwt_secret,
            "VERIFY_JWT": String(false)
        }

        await Deno.writeTextFile(`./.env.defaults`, stringify(defaultEnvVars));

        console.log(config)

    } catch (e) {
        console.log(`[init]`, e)
    }

}

