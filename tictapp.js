#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

// import "https://deno.land/std@0.177.0/dotenv/load.ts";
import { parse as parseArgs } from "https://deno.land/std@0.170.0/flags/mod.ts";
// import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
// import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

import _status from "./status.js";
import _logs from "./logs.js";
import _init from "./init.js";

async function getJson(filePath) {
    return JSON.parse(await Deno.readTextFile(filePath));
}

const json = await getJson(`./tictapp.json`)

const { token, deno_deploy_token, deno_deploy_org, profile, project } = json

if (deno_deploy_token) {
    Deno.env.set('API_TOKEN', token)
    Deno.env.set('PROJECT_REF', project.ref)
    Deno.env.set('DENO_DEPLOY_TOKEN', deno_deploy_token)
    Deno.env.set('DENO_DEPLOY_ORG', deno_deploy_org)
}

const args = parseArgs(Deno.args, {
    alias: {
        'p': 'prod'
    },
    boolean: [
        'prod'
    ],
    default: {
        prod: true
    }
})

const subcommand = args._.shift()

switch (subcommand) {
    case "init":
        _init(args)
        break
    case "status":
        _status(args)
        break
    case "logs":
        _logs(args)
        break
    default:
        console.log(`Invalid subcomand: ${subcommand}`)
}
