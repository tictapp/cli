import "https://deno.land/std@0.177.0/dotenv/load.ts";
import deploy from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { Select } from "https://deno.land/x/cliffy@v0.25.7/prompt/select.ts";
import { colors, tty } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";

export default async function _api(args) {

    const TOKEN = Deno.env.get('TOKEN')

    let PROJECT_REF = args.project || Deno.env.get('PROJECT_REF')
    //console.log('PROJECT_REF', PROJECT_REF)

    if (!PROJECT_REF || PROJECT_REF === true) {
        const studio_api = StudioAPI.fromToken(TOKEN)
        const studio_projects = await studio_api.requestJson(`/projects`)
        if (studio_projects.error) {
            console.log(studio_projects)
            Deno.exit()
        }
        // console.table(studio_projects.map(o => ({ name: o.name, value: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })))
        // PROJECT_REF = prompt(`Enter project ref`)

        PROJECT_REF = await Select.prompt({
            message: "Pick a project",
            options: studio_projects.map(o => ({ name: `${o.ref} - ${o.name}`, value: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })),
        });

    }

    const studioAPI = StudioAPI.fromToken(TOKEN)
    const project = await studioAPI.requestJson(`/projects/${PROJECT_REF}?_data`)

    if (project.error) {
        console.log(project)
        Deno.exit()
    }

    //console.log(project)

    const dbUri = `postgresql://supabase_admin:${project.db_pass}@db.tictapp.io:${project.db_port}/postgres`

    console.log(`

${colors.underline.bold('Name')}
${colors.bgBlack("\n  \n   " + project.name + " \n ")}

${colors.underline.bold('Project Ref')}
${colors.bgBlack("\n  \n   " + project.ref + " \n ")}

${colors.underline.bold('Anon Key')}
${colors.bgBlack("\n  \n   " + project.anon_key + " \n ")}

${colors.underline.bold('Service Key')}
${colors.bgBlack("\n  \n   " + project.service_key + " \n ")}

${colors.underline.bold('JWT Secret')}
${colors.bgBlack("\n  \n   " + project.jwt_secret + " \n ")}

${colors.underline.bold('Database Connection String')}
${colors.bgBlack("\n  \n   " + dbUri + " \n ")}

${colors.bold.underline('Endpoints')}
${colors.bgBlack(`

    ${colors.dim('API')}
    ${colors.brightBlue(`https://${project.endpoint}`)}

    ${colors.dim('Studio')}
    ${colors.brightBlue(`https://${project.endpoint.replace('.io', ".studio")}`)}

    ${colors.dim('Functions')}
    ${colors.brightBlue(`https://${project.endpoint.replace('.io', ".fun")}`)}
`)}
`)

}