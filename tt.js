import { Command, ValidationError, CompletionsCommand, UpgradeCommand, DenoLandProvider, GithubProvider, colors } from "./deps.js";
import { VERSION } from './version.js'
import { getLogin, getJson, exists } from "./helpers.js";

import projectsCommand from './projects/index.js'
import functionsCommand from "./functions/index.js";
import statusCommand from './status/index.js'
import linkCommand from './link/index.js'


const login = await getLogin()

if (login) {
    Deno.env.set('TOKEN', login.token)
    Deno.env.set('DENO_DEPLOY_TOKEN', login.deno_deploy_token)
    Deno.env.set('DENO_DEPLOY_ORG', login.deno_deploy_org)
}

if (!Deno.env.get("FUNCTIONS_DOMAIN"))
    Deno.env.set("FUNCTIONS_DOMAIN", 'tictapp.fun')


await new Command()
    // Main command.
    .name("tt")
    .version(VERSION)
    .description("Command line interface for tictapp")
    .globalOption("-d, --debug", "Enable debug output.")
    .globalOption("-w, --workdir [path:file]", "Specify project working directory", {
        //default: false
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