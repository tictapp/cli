
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { exists } from "./helpers.js";


export default async function _env(args) {

    const functionName = args._.shift()

    const envVars = await load({
        envPath: `functions/${functionName}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });

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
            entrypoint
        ],
        env: envVars,
    });

    await p.status()

}
