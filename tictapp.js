#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

// import "https://deno.land/std@0.177.0/dotenv/load.ts";
import { parse as parseArgs } from "https://deno.land/std@0.170.0/flags/mod.ts";

import _status from "./status.js";
import _logs from "./logs.js";
import _init from "./init.js";
import _deploy from "./deploy.js";
import _env from "./env.js";
import _new from "./new.js";
import _delete from "./delete.js";

import { getJson, exists } from "./helpers.js";

if (!Deno.env.get("FUNCTIONS_DOMAIN"))
    Deno.env.set("FUNCTIONS_DOMAIN", 'tictapp.fun')

if (await exists('./tictapp.json')) {

    const json = await getJson(`./tictapp.json`)

    const { token, deno_deploy_token, deno_deploy_org, profile, project } = json

    if (deno_deploy_token) {
        Deno.env.set('TOKEN', token)
        Deno.env.set('PROJECT_REF', project.ref)
        Deno.env.set('DENO_DEPLOY_TOKEN', deno_deploy_token)
        Deno.env.set('DENO_DEPLOY_ORG', deno_deploy_org)
    }

}

const args = parseArgs(Deno.args, {
    alias: {
        'p': 'prod',
        's': 'static'
    },
    boolean: [
        'prod',
        'static',
        'verify-jwt'
    ],
    default: {
        prod: true,
        static: true,
        'verify-jwt': false
    }
})

const subcommand = args._.shift()

switch (subcommand) {
    case "init":
        _init(args)
        break
    case "deploy":
        _deploy(args)
        break
    case "new":
        _new(args)
        break
    case "delete":
        _delete(args)
        break
    case "env":
        _env(args)
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
