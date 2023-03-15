import { Command, ValidationError, CompletionsCommand, UpgradeCommand, DenoLandProvider, GithubProvider, colors } from "./deps.js";
import { VERSION } from './version.js'
import { getLogin, getJson, exists } from "./helpers.js";

import projectsCommand from './projects/index.js'
import functionsCommand from "./functions/index.js";
import statusCommand from './status/index.js'
import linkCommand from './link/index.js'
import loginCommand from './loginCommand/index.js'

const login = await getLogin()

if (login) {
    Deno.env.set('TOKEN', login.token)
    Deno.env.set('DENO_DEPLOY_TOKEN', login.deno_deploy_token)
}

//console.log('login', login)

if (await exists('./tictapp.json')) {

    const { project } = await getJson(`./tictapp.json`)

    if (project) {
        Deno.env.set('PROJECT_REF', project.ref)
    }

}


if (!Deno.env.get("FUNCTIONS_DOMAIN"))
    Deno.env.set("FUNCTIONS_DOMAIN", 'tictapp.fun')


await new Command()
    // Main command.
    .name("tt")
    .version(VERSION)
    .description("Command line interface for tictapp")
    .meta('Account', login ? login.profile.primary_email : 'Unauthorized')
    .globalOption("-d, --debug", "Enable debug output.")
    .globalOption("-w, --workdir [path:file]", "Specify project working directory", {
        default: '.',
        async action(options) {
            try {
                Deno.chdir(options.workdir)
            } catch (e) {
                throw new ValidationError(e)
            }

            if (await exists('./tictapp.json')) {

                const { project } = await getJson(`./tictapp.json`)

                if (project) {
                    Deno.env.set('PROJECT_REF', project.ref)
                }

            }
            console.log(`Project path: ${colors.magenta(Deno.cwd())}`)
            if (Deno.env.get('PROJECT_REF'))
                console.log(`${colors.green(`https://tictapp.studio/project/${Deno.env.get('PROJECT_REF')}`)}`)
        }
    })
    .arguments("[command]")
    .action(function () {
        //console.log('MAIN action', a)
        this.showHelp();
        return;
    })
    .command('login', loginCommand())
    .command('link', linkCommand())
    .command('projects', projectsCommand())
    .command('functions', functionsCommand())
    .command('status', statusCommand())
    .command("completions", new CompletionsCommand())
    .command("upgrade", new UpgradeCommand({
        main: "tt.js",
        args: ["--allow-all"],
        provider: [
            new GithubProvider({ repository: "serebano/tictapp-cli" }),
            new DenoLandProvider({ name: 'tictapp' }),
        ],
    }))

    .parse(Deno.args);