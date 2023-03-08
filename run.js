
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { exists, getJson } from "./helpers.js";
import { Select } from "https://deno.land/x/cliffy@v0.25.7/prompt/select.ts";
import { colors } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";


export default async function _run(args) {

    let functionName = args._.shift()
    let funPath = `./functions/${functionName}`

    if (!functionName) {
        funPath = Deno.cwd()
        functionName = funPath.split("/").pop()

        Deno.chdir('../../')

        if (await exists('./tictapp.json')) {
            const { project } = await getJson(`./tictapp.json`)
            if (project) {
                Deno.env.set('PROJECT_REF', project.ref)
            }
        }

        console.log(colors.red(`Function Auto`), { funPath, functionName, cwd: Deno.cwd() })
        //Deno.exit()
    }

    const envVars = await load({
        envPath: `functions/${functionName}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });

    if ((await exists(`./functions/${functionName}/deno.json`))) {
        const p = Deno.run({
            cmd: [
                Deno.execPath(),
                "task",
                "--config",
                `./functions/${functionName}/deno.json`,
                "--cwd",
                `./functions/${functionName}`,
                "start"
            ],
            env: envVars,
        });

        await p.status()
    } else {

        let entrypoint = `./functions/${functionName}/index.js`

        if (!(await exists(entrypoint)))
            entrypoint = `./functions/${functionName}/index.ts`

        if (!(await exists(entrypoint))) {
            console.error(`Entrypoint failed: ${entrypoint}`)
            Deno.exit()
        }

        const p = Deno.run({
            cmd: [
                Deno.execPath(),
                "run",
                "--allow-all",
                "--watch",
                "--import-map",
                `./functions/import_map.json`,
                entrypoint
            ],
            env: envVars,
        });

        await p.status()
    }

}
