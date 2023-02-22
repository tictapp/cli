#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import { API as DenoAPI } from "./api_deno.js";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

export default async function _env(args) {

    const functionName = args._.shift()

    const PROJECT_REF = Deno.env.get('PROJECT_REF')
    const DENO_DEPLOY_TOKEN = Deno.env.get("DENO_DEPLOY_TOKEN")
    const DENO_DEPLOY_PROJECT = `${PROJECT_REF}-${functionName}`

    const envVars = await load({
        envPath: `functions/${functionName}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });

    const denoAPI = DenoAPI.fromToken(DENO_DEPLOY_TOKEN)
    const denoProject = await denoAPI.getProject(DENO_DEPLOY_PROJECT);

    if (denoProject === null) {

        console.log('denoProject doesnt exists')

    } else {

        const res = await denoAPI.requestJson(`/projects/${denoProject.id}/env`, {
            method: 'PATCH',
            body: envVars
        })

        console.log(res.envVars)
    }

}