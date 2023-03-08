import "https://deno.land/std@0.177.0/dotenv/load.ts";
import { API as StudioAPI } from "./api_studio.js";
import { Select } from "https://deno.land/x/cliffy@v0.25.7/prompt/select.ts";
import { colors } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";

export default async function _backup(args) {

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

    console.log("\n", colors.bold.italic('Backup running...'), "\n")

    const dbUri = `postgresql://supabase_admin:${project.db_pass}@db.tictapp.io:${project.db_port}/postgres`

    await Deno.mkdir("./backup", { recursive: true });

    const backupFilePath = `./backup/${project.ref}-${Date.now()}.sql`

    const p = Deno.run({
        cmd: [
            "pg_dumpall",
            "-d",
            dbUri,
            `-f`,
            backupFilePath
        ],
        env: {
            PGPASSWORD: project.db_pass
        },
    });

    await p.status()

    console.log(`
${colors.bold.underline('Backup')}
${colors.bgBlack(`

    ${colors.dim('Connection String')}
    ${colors.brightBlue(dbUri)}

    ${colors.dim('Backup File Path')}
    ${colors.brightGreen(backupFilePath)}

    ${colors.dim('Restore Command')}
    ${colors.bold(`psql '${dbUri}' -f ${backupFilePath}`)}
`)}
`)

}