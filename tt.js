import { Command, ValidationError, CompletionsCommand, UpgradeCommand, DenoLandProvider, GithubProvider, colors } from "./deps.js";
import { VERSION } from './version.js'
import { getLogin, getJson, exists } from "./helpers.js";

import projectsCommand from './projectsCommand/index.js'
import functionsCommand from "./functionsCommand/index.js";

import statusCommand from './statusCommand/index.js'
import loginCommand from './loginCommand/index.js'
import linkCommand from './linkCommand/index.js'
import genCommand from './genCommand/index.js'


const login = await getLogin()

if (login) {
    Deno.env.set('TOKEN', login.token)
    Deno.env.set('DENO_DEPLOY_TOKEN', login.deno_deploy_token)
}

//console.log('login', login)
let project
if (await exists('./tictapp.json')) {
    const cfg = await getJson(`./tictapp.json`)
    if (cfg && cfg.project) {
        project = cfg.project
        Deno.env.set('PROJECT_REF', project.ref)
    }
}


if (!Deno.env.get("FUNCTIONS_DOMAIN"))
    Deno.env.set("FUNCTIONS_DOMAIN", 'tictapp.fun')


const tt = new Command()
    // Main command.
    .name("tt")
    .version(VERSION)

if (login) {
    tt.meta('Profile', login && colors.cyan(login.profile.primary_email))
}

if (project) {
    tt.meta('Project', project && `${colors.bold(project.name || '*')} ${colors.dim(project.ref)} ${colors.green(project.endpoint)}`)
}

tt.meta('Workdir', colors.dim(Deno.cwd()))

tt.description(`Command line interface for tictapp
https://github.com/tictapp/cli`)

    //.meta('Account', login ? login.profile.primary_email : 'Unauthorized')
    .globalOption("-d, --debug", "Enable debug output.")
    .globalOption("-w, --workdir [path:file]", "Specify project working directory", {
        default: './',
        async action(options) {
            try {
                Deno.chdir(options.workdir)
            } catch (e) {
                throw new ValidationError(e)
            }

            project = null
            Deno.env.delete('PROJECT_REF')

            if (await exists('./tictapp.json')) {
                const cfg = await getJson(`./tictapp.json`)
                if (cfg && cfg.project) {
                    project = cfg.project
                    Deno.env.set('PROJECT_REF', project.ref)
                }
            }
            // console.log(this)

            this.meta('Workdir', colors.dim(Deno.cwd()))
            this.meta('Project', project
                ? `${colors.bold(project.name || '*')} ${colors.dim(project.ref)} ${colors.green(project.endpoint)}`
                : colors.dim(`Not linked`))
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
    .command('status', statusCommand())
    .command('gen', genCommand())

    .command('projects', projectsCommand())
    .command('functions', functionsCommand())

    .command("completions", new CompletionsCommand())
    .command("upgrade", new UpgradeCommand({
        main: "tt.js",
        args: ["--allow-all"],
        provider: [
            new DenoLandProvider({ name: 'tictapp' }),
            new GithubProvider({ repository: "serebano/tictapp-cli" })
        ],
    }))

    .parse(Deno.args);

await tt