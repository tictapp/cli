import { selectProject } from "../helpers.js";
import { API as StudioAPI } from "../api_studio.js";
import { colors, Command } from '../deps.js'

export default function projectsInfoCommand() {
    return new Command()
        .name("types")
        .description("Generate database types for TypeScript")
        .arguments('<file:file>', 'Types file path')
        .option('-p, --project <name:string>', 'Project ref')
        .action(async (options, filepath) => {

            let project_ref = Deno.env.get('PROJECT_REF')

            if (options.project)
                project_ref = options.project === true ? undefined : options.project

            if (!project_ref)
                project_ref = await selectProject()

            // const spinner = wait(`Checking function "${func_slug}"...`).start()

            const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
            const project = await studioAPI.getProject(project_ref, true)

            const dbUri = `postgresql://supabase_admin:${project.db_pass}@db.tictapp.io:${project.db_port}/postgres`

            const sb_cmd = `supabase gen types typescript --db-url "${dbUri}" > ${filepath}`

            console.log(colors.yellow.dim.italic(sb_cmd))

            await Deno.remove(filepath).catch(() => { })

            const f = Deno.openSync(filepath, {
                read: true,
                write: true,
                create: true,
                append: false
            })

            const p = Deno.run({
                cmd: [
                    "supabase",
                    "gen",
                    "types",
                    "typescript",
                    "--db-url",
                    dbUri,

                ],
                stdout: f.rid
            });

            const status = await p.status();
            f.close()

            console.log(status)

        })
}