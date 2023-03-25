import { selectProject } from "../helpers.js";
import { API as StudioAPI } from "../api_studio.js";
import { colors, Command } from '../deps.js'

export default function projectsInfoCommand() {
    return new Command()
        .name("info")
        .description("Get project info")
        .option('-p --project <name:string>')
        .action(async (options) => {

            let project_ref = Deno.env.get('PROJECT_REF')

            if (options.project)
                project_ref = options.project === true ? undefined : options.project

            if (!project_ref)
                project_ref = await selectProject()

            // const spinner = wait(`Checking function "${func_slug}"...`).start()

            const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
            const project = await studioAPI.getProject(project_ref, true)

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

${colors.underline.bold('Database Connection')}
${colors.bgBlack(`

    ${colors.bold(`Connection URI`)}
    ${colors.blue("" + dbUri)}

    ${colors.bold(`DB Host`)}
    ${colors.blue("db.tictapp.io")}

    ${colors.bold(`DB Port`)}
    ${colors.blue("" + project.db_port)}

    ${colors.bold(`DB Password`)}
    ${colors.blue("" + project.db_pass)}
`)}

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

        })
}