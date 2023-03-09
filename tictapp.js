#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import { parseArgs, semverGreaterThanOrEquals } from "./deps.js";

import _login from "./login.js";
import _status from "./status.js";
import _logs from "./logs.js";
import _init from "./init.js";
import _deploy from "./deploy.js";
import _env from "./env.js";
import _new from "./new.js";
import _delete from "./delete.js";
import _upgrade from "./upgrade.js";
import _link from "./link.js";
import _run from "./run.js";
import _api from "./api.js";
import _backup from "./backup.js";


import _projects from "./projects/index.js";


import { VERSION } from "./version.js";

import { getJson, exists, fetchReleases, getConfigPaths, getLogin } from "./helpers.js";
import { error } from "./error.js";

const login = await getLogin()

if (login) {
    Deno.env.set('TOKEN', login.token)
    Deno.env.set('DENO_DEPLOY_TOKEN', login.deno_deploy_token)
    Deno.env.set('DENO_DEPLOY_ORG', login.deno_deploy_org)
}

const MINIMUM_DENO_VERSION = "1.20.0";


if (!Deno.env.get("FUNCTIONS_DOMAIN"))
    Deno.env.set("FUNCTIONS_DOMAIN", 'tictapp.fun')

const help = `
tictapp ${VERSION}

Command line tool for tictapp.
`;

if (!semverGreaterThanOrEquals(Deno.version.deno, MINIMUM_DENO_VERSION)) {
    error(
        `The Deno version you are using is too old. Please update to Deno ${MINIMUM_DENO_VERSION} or later. To do this run \`deno upgrade\`.`,
    );
}



if (await exists('./tictapp.json')) {

    const json = await getJson(`./tictapp.json`)

    const { token, deno_deploy_token, deno_deploy_org, profile, project } = json

    if (deno_deploy_token) {
        //Deno.env.set('TOKEN', token)
        Deno.env.set('PROJECT_REF', project.ref)
        //Deno.env.set('DENO_DEPLOY_TOKEN', deno_deploy_token)
        //Deno.env.set('DENO_DEPLOY_ORG', deno_deploy_org)
    }

}

const args = parseArgs(Deno.args, {
    alias: {
        'p': 'project'
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

if (Deno.isatty(Deno.stdin.rid)) {
    let latestVersion;
    // Get the path to the update information json file.
    const { updatePath } = getConfigPaths();
    // Try to read the json file.
    const updateInfoJson = await Deno.readTextFile(updatePath).catch((error) => {
        if (error.name == "NotFound") return null;
        console.error(error);
    });

    if (updateInfoJson) {
        const updateInfo = JSON.parse(updateInfoJson)

        const moreThanADay =
            Math.abs(Date.now() - updateInfo.lastFetched) > 1 * 60 * 60 * 1000;
        // Fetch the latest release if it has been more than a day since the last
        // time the information about new version is fetched.
        if (moreThanADay) {
            fetchReleases();
        } else {
            latestVersion = updateInfo.latest;
        }
    } else {
        fetchReleases();
    }

    // If latestVersion is set we need to inform the user about a new release.
    if (
        latestVersion &&
        !(semverGreaterThanOrEquals(VERSION, latestVersion.toString()))
    ) {
        console.log(
            [
                `\nA new release of tictapp is available: ${VERSION} -> ${latestVersion}`,
                "To upgrade, run `tictapp upgrade`",
                `https://github.com/serebano/tictapp/releases/tag/${latestVersion}\n`,
            ].join("\n"),
        );
    }
}

const subcommand = args._.shift()

//console.log(`tictapp ${VERSION}`)

switch (subcommand) {
    case "login":
        await _login(args)
        break
    case "init":
        await _init(args)
        break
    case "link":
        await _link(args)
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
    case "run":
        await _run(args)
        break
    case "api":
        await _api(args)
        break
    case "backup":
        await _backup(args)
        break

    case "projects":
        await _projects(args)
        break

    default:
        console.log(help)
}
