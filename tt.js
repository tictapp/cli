import { Command, ValidationError, CompletionsCommand, UpgradeCommand, DenoLandProvider, GithubProvider, colors } from "./deps.js";
import { VERSION } from './version.js'
import { getLogin, getJson, exists } from "./helpers.js";

import projectsCommand from './projectsCommand/index.js'
import functionsCommand from "./functionsCommand/index.js";

import loginCommand from './loginCommand/index.js'
import linkCommand from './linkCommand/index.js'
import genCommand from './genCommand/index.js'
import vercelCommand from './vercelCommand/index.js'


// new
import whoamiCommand from './whoamiCommand/index.js'


const login = await getLogin()

if (login) {
    Deno.env.set('TOKEN', login.token)

    if (login.deno_deploy_token)
        Deno.env.set('DENO_DEPLOY_TOKEN', login.deno_deploy_token)

    if (login.vercel_token)
        Deno.env.set('VERCEL_ACCESS_TOKEN', login.vercel_token)
}

let project
if (await exists('./tictapp.json')) {
    const cfg = await getJson(`./tictapp.json`)
    if (cfg && cfg.project) {
        project = cfg.project
        Deno.env.set('PROJECT_REF', project.ref)
    }
}


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

tt.description(`The tictapp command line interface
https://github.com/tictapp/cli`)

    //.meta('Account', login ? login.profile.primary_email : 'Unauthorized')
    .globalOption("-d, --debug", "Enable debug output.")
    .globalOption("-w, --workdir [path:file]", "Specify project working directory", {
        //default: './',
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
    .command('whoami', whoamiCommand)

    .command('link', linkCommand())
    .command('gen', genCommand())
    .command('vercel', vercelCommand())

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