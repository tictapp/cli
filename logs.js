#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import "https://deno.land/std@0.177.0/dotenv/load.ts";
import logs from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/logs.ts"
import { API, APIError } from "https://raw.githubusercontent.com/denoland/deployctl/main/src/utils/api.ts"
import { parse as parseArgs } from "https://deno.land/std@0.170.0/flags/mod.ts";
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";

const args = parseArgs(Deno.args, {
    boolean: [
        'verify-jwt'
    ]
})

const name = args._[0]

console.log('args', args)

const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
const project = await studioAPI.requestJson(`/projects/${Deno.env.get('PROJECT')}?_data`)

const opts = {
    token: 'ddp_ebahKKeZqiZVeOad7KJRHskLeP79Lf0OJXlj',
    project: `${project.ref}-${name}`
}


//const denoAPI = DenoAPI.fromToken(opts.token);
//const func = await denoAPI.getProject(opts.project);

// await logs({
//     token: opts.token,
//     prod: true,
//     project: opts.project,
//     _: []
// })

export default async function _logs(args) {
    const fun_name = args._.shift()

    console.log('args', args)

    await logs({
        //token: args.token,
        prod: args.prod,
        project: `${Deno.env.get('PROJECT_REF')}-${fun_name}`,
        _: []
    })
}