#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import "https://deno.land/std@0.177.0/dotenv/load.ts";
import deploy from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"
import logs from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/logs.ts"
import { API, APIError } from "https://raw.githubusercontent.com/denoland/deployctl/main/src/utils/api.ts"
import { parse as parseArgs } from "https://deno.land/std@0.170.0/flags/mod.ts";
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";


const args = parseArgs(Deno.args)

const name = args._[0]

const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
const project = await studioAPI.requestJson(`/projects/${Deno.env.get('PROJECT')}?_data`)

const opts = {
    token: 'ddp_ebahKKeZqiZVeOad7KJRHskLeP79Lf0OJXlj',
    project: `${project.ref}-${name}`,
    organizationId: "75fa843c-7493-4626-8440-d05bf0802bf5"
}


// const denoAPI = DenoAPI.fromToken(opts.token);
// const func = await denoAPI.getProject(opts.project);

// const defaultEnvVars = {
//     "SUPABASE_REF": project.ref,
//     "SUPABASE_URL": `https://${project.endpoint}`,
//     "SUPABASE_ANON_KEY": project.anon_key,
//     "SUPABASE_SERVICE_KEY": project.service_key,
//     "JWT_SECRET": project.jwt_secret,
//     "VERIFY_JWT": String(args['verify-jwt'])
// }


//await Deno.writeTextFile(`.env.defaults`, stringify(defaultEnvVars));

const envVars = await load({
    envPath: `functions/${name}/.env`,
    defaultsPath: `.env.defaults`,
    export: false
});

async function exists(path) {
    try {
        return (await Deno.stat(path)).isFile;
    } catch {
        return false;
    }
}

let entrypoint = `./functions/${name}/index.js`

if (!(await exists(entrypoint)))
    entrypoint = `./functions/${name}/index.ts`

if (!(await exists(entrypoint))) {
    console.error(`Entrypoint failed: ${entrypoint}`)
    Deno.exit()
}

const p = Deno.run({
    cmd: ["deno", "run", "--allow-all", "--watch", entrypoint],
    env: envVars,
    //stderr: 'piped', stdout: 'piped'
});

// const [status, stdout, stderr] = await Promise.all([
//     p.status(),
//     p.output(),
//     p.stderrOutput()
// ]);
// p.close();

console.log(`RUN`, await p.status())

Deno.exit()

if (func === null) {

    const res = await denoAPI.requestJson('/projects', {
        method: 'POST',
        body: {
            "name": opts.project,
            "organizationId": opts.organizationId,
            "envVars": envVars
        }
    })

    console.log('new func --> ', res)

} else {

    // const lines = Object.keys(defaultEnvVars).map(key => {
    //     return `${key}=${defaultEnvVars[key]}`
    // }).join("\n")

    // const res = await denoAPI.requestJson(`/projects/${func.id}/env`, {
    //     method: 'PATCH',
    //     body: defaultEnvVars
    // })

    console.log('exists', 'hasProductionDeployment =>', func.hasProductionDeployment)
}


await deploy({
    token: opts.token,
    prod: true,
    project: opts.project,
    static: true,
    include: `functions`,
    _: [entrypoint]
})

console.log(`

Endpoint:
    https://${project.ref}.tictapp.fun/${name}

Environment:
${JSON.stringify(defaultEnvVars, null, 4)}
`)

Deno.exit()

const api = API.fromToken(opts.token);
const _project = await api.getProject(opts.project);

if (_project === null) {

    const token = Deno.env.get('TOKEN')
    const ref = Deno.env.get('PROJECT')

    if (!token || !ref)
        Deno.exit(1);

    const payload = {
        name,
        verify_jwt: args['verify-jwt']
    }

    const options = {
        method: 'POST',
        headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
    };

    const res = await fetch(`https://api.tictapp.studio/admin/projects/${ref}/functions`, options)
    if (res.ok) {
        const data = await res.json()
        console.log('DATA', data)
    } else {
        console.error('error', res.status, res.statusText)
        Deno.exit(1);
    }
}


await deploy({
    token: opts.token,
    prod: true,
    project: opts.project,
    static: true,
    include: `functions`,
    _: [`functions/${name}/index.js`]
})