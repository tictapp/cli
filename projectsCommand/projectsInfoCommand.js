import { selectProject } from "../helpers.js";
import { API as StudioAPI } from "../api_studio.js";
import { colors, Command } from '../deps.js'

export default function projectsInfoCommand() {
    return new Command()
        .name("info")
        .description("Get project info")
        .option('-p --project <name:string>', 'Prpject ref')
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

            // ${colors.bold('Name')}
            // ${("\n  \n   " + project.name + " \n ")}

            // ${colors.bold('Project Ref')}
            // ${("\n  \n   " + project.ref + " \n ")}


            console.log(`

${colors.underline.bold('JWT Keys')}
${(`

    ${colors.bold(`Anon Key`)}
    ${colors.blue(project.anon_key)}

    ${colors.bold(`Service Key`)}
    ${colors.blue(project.service_key)}

    ${colors.bold(`JWT Secret`)}
    ${colors.blue(project.jwt_secret)}
`)}

${colors.underline.bold('Database Connection')}
${(`

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
${(`

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