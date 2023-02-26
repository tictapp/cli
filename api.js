import "https://deno.land/std@0.177.0/dotenv/load.ts";
import deploy from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

export default async function _api(args) {

    const TOKEN = Deno.env.get('TOKEN')

    let PROJECT_REF = args.project || Deno.env.get('PROJECT_REF')
    console.log('PROJECT_REF', PROJECT_REF)
    if (!PROJECT_REF || PROJECT_REF === true) {
        const studio_api = StudioAPI.fromToken(TOKEN)
        const studio_projects = await studio_api.requestJson(`/projects`)
        if (studio_projects.error) {
            console.log(studio_projects)
            Deno.exit()
        }
        console.table(studio_projects.map(o => ({ name: o.name, ref: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })))

        PROJECT_REF = prompt(`Enter project ref`)
    }

    const studioAPI = StudioAPI.fromToken(TOKEN)
    const project = await studioAPI.requestJson(`/projects/${PROJECT_REF}?_data`)

    if (project.error) {
        console.log(project)
        Deno.exit()
    }

    console.log(project)

    const dbUri = `postgresql://supabase_admin:${project.db_pass}@db.tictapp.io:${project.db_port}/postgres`

    console.log(`
Name
${project.name}

Ref
${project.ref}

Endpoint
https://${project.endpoint}

Anon Key
${project.anon_key}

Service Key
${project.service_key}

JWT Secret
${project.jwt_secret}

DB URI
${dbUri}    
    `)

}