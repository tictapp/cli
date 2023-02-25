#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check
import { getJson, exists, getLogin } from "./helpers.js";
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";

export default async function status() {
    const FUNCTIONS_DOMAIN = Deno.env.get("FUNCTIONS_DOMAIN")

    const login = await getLogin()

    if (login) {
        console.log(login)

        const studio_api = StudioAPI.fromToken(login.token)
        const deno_api = DenoAPI.fromToken(login.deno_deploy_token)

        const studio_profile = await studio_api.requestJson(`/projects`)
        const deno_profile = await deno_api.requestJson(`/projects`)
        console.table(deno_profile.map(o => ({ name: o.name, id: o.id, updated: o.updatedAt })))
        console.table(studio_profile.map(o => ({ name: o.name, ref: o.ref, updated: o.updated_at })))

        //console.log(studio_profile, deno_profile)
    }

    if (!await exists('./tictapp.json')) {
        console.log(`No project found. run tictapp init`)
        Deno.exit()
    }


    const json = await getJson(`./tictapp.json`)

    const { profile, project } = json

    console.log(`
%c${profile.primary_email}

%c${project.name}  %c${project.status}%c

Api:        https://${project.endpoint}
Functions:  https://${project.ref}.${FUNCTIONS_DOMAIN}
`,
        "color: orange",
        "color: aquamarine;font-weight:bold",
        "background-color: grey",
        `color: blue`,
    );

}