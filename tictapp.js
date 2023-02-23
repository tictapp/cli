#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import { parseArgs } from "./deps.js";

import _status from "./status.js";
import _logs from "./logs.js";
import _init from "./init.js";
import _deploy from "./deploy.js";
import _env from "./env.js";
import _new from "./new.js";
import _delete from "./delete.js";
import _upgrade from "./upgrade.js";
import { VERSION } from "./version.js";

import { getJson, exists } from "./helpers.js";

if (!Deno.env.get("FUNCTIONS_DOMAIN"))
    Deno.env.set("FUNCTIONS_DOMAIN", 'tictapp.fun')

const help = `tictapp ${VERSION}
Command line tool for tictapp.
To deploy a local script:
  deployctl deploy --project=helloworld ./main.ts
To deploy a remote script:
  deployctl deploy --project=helloworld https://deno.land/x/deploy/examples/hello.js
SUBCOMMANDS:
    deploy    Deploy a script with static files to Deno Deploy
    upgrade   Upgrade deployctl to the given version (defaults to latest)
    logs      Stream logs for the given project
`;

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
    }
})

const subcommand = args._.shift()

console.log(`tictapp ${VERSION}`)

switch (subcommand) {
    case "init":
        await _init(args)
        break
    case "deploy":
        await _deploy(args)
        break
    case "new":
        await _new(args)
        break
    case "delete":
        await _delete(args)
        break
    case "env":
        await _env(args)
        break
    case "status":
        await _status(args)
        break
    case "logs":
        await _logs(args)
        break
    case "upgrade":
        await _upgrade(args)
        break
    default:
        console.log(help)
}
