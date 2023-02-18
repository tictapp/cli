#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import "https://deno.land/std@0.177.0/dotenv/load.ts";
import deploy from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"
import logs from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/logs.ts"
import { API, APIError } from "https://raw.githubusercontent.com/denoland/deployctl/main/src/utils/api.ts"
import { parse as parseArgs } from "https://deno.land/std@0.170.0/flags/mod.ts";
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";


const args = parseArgs(Deno.args, {
    boolean: [
        'verify-jwt'
    ]
})

const name = args._[0]

const envVars = await load({
    envPath: `functions/${name}/.env`,
    defaultsPath: `.env.defaults`,
    export: false
});

console.log('args', args, envVars)

//Deno.exit()

const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
const project = await studioAPI.requestJson(`/projects/${Deno.env.get('PROJECT')}?_data`)

const opts = {
    token: 'ddp_ebahKKeZqiZVeOad7KJRHskLeP79Lf0OJXlj',
    project: `${project.ref}-${name}`
}


const denoAPI = DenoAPI.fromToken(opts.token);

const func = await denoAPI.getProject(opts.project);

if (func === null) {

    console.log('func doesnt exists')

} else {

    const res = await denoAPI.requestJson(`/projects/${func.id}/env`, {
        method: 'PATCH',
        body: envVars

        // body: {
        //     "SUPABASE_REF": project.ref,
        //     "SUPABASE_URL": `https://${project.endpoint}`,
        //     "SUPABASE_ANON_KEY": project.anon_key,
        //     "SUPABASE_SERVICE_KEY": project.service_key,
        //     "JWT_SECRET": project.jwt_secret,

        //     //"VERIFY_JWT": String(args['verify-jwt']),

        // }
    })

    console.log('env', res)
}

Deno.exit()