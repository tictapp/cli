import { Command, CompletionsCommand, UpgradeCommand, DenoLandProvider, GithubProvider } from "./deps.js";
import { VERSION } from './version.js'
import { getLogin } from "./helpers.js";

import projectsCommand from './projects/index.js'
import functionsCommand from "./functions/index.js";
import statusCommand from './status/index.js'


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
    .arguments("[command]")
    .action(function (...a) {
        console.log('MAIN action', a)
        this.showHelp();
        return;
    })
    .command('projects', projectsCommand())
    .command('functions', functionsCommand())
    .command('status', statusCommand())
    .command("upgrade", new UpgradeCommand({
        main: "tt.js",
        args: ["--allow-all"],
        provider: [
            new GithubProvider({ repository: "serebano/tictapp-cli" }),
            new DenoLandProvider({ name: 'tictapp' }),
        ],
    }))
    .command("completions", new CompletionsCommand())

    .parse(Deno.args);