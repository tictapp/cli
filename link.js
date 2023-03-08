import { API as StudioAPI } from "./api_studio.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { getJson, writeJson, exists, getLogin } from "./helpers.js";
import { Select } from "https://deno.land/x/cliffy@v0.25.7/prompt/select.ts";
import { colors, tty } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";
import _api from './api.js'

export default async function _link(args) {

    const configFile = `./tictapp.json`
    let config = {}

    if ((await exists(configFile)))
        config = await getJson(configFile)


    try {
        const login = await getLogin()

        if (!login) {
            console.log(`You must login first
            tictapp login`)
            Deno.exit()
        }

        config.token = login.token
        config.profile = login.profile

        //const api = StudioAPI.fromToken(config.token)
        //const projects = await api.requestJson(`/projects`)

        // const projectsList = projects.map(p => {
        //     return {
        //         ref: p.ref,
        //         name: p.name,
        //         //endpoint: p.endpoint,
        //         status: p.status,
        //         created: p.inserted_at
        //     }
        // })

        //console.log('init', { token, profile, projects })

        //         console.table(projectsList)

        //         const project_ref = prompt(`
        // Set your project ref
        // (project.ref) =`, config.project?.ref)

        //if (!PROJECT_REF || PROJECT_REF === true) {
        const studio_api = StudioAPI.fromToken(Deno.env.get('TOKEN'))
        const studio_projects = await studio_api.requestJson(`/projects`)
        if (studio_projects.error) {
            console.log(studio_projects)
            Deno.exit()
        }
        // console.table(studio_projects.map(o => ({ name: o.name, value: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })))
        // PROJECT_REF = prompt(`Enter project ref`)

        const project_ref = await Select.prompt({
            message: "Select project to link",
            options: studio_projects.map(o => ({
                name: `${colors.bgBrightBlue.brightWhite(" " + o.ref + " ")}  ${colors.brightBlue(o.endpoint)}  ${colors.brightWhite.bold(o.name)}`,
                value: o.ref
            })),
        });

        //}

        const project = await studio_api.requestJson(`/projects/${project_ref}?_data`)

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

        config.deno_deploy_token = login.deno_deploy_token
        config.deno_deploy_org = login.deno_deploy_org

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

        _api({
            project: project.ref
        })

        // console.log(config)

    } catch (e) {
        console.log(`[link]`, e)
    }

}

