#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import { API as DenoAPI } from "./api_deno.js";
import { load, parse, stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

export default async function _env(args) {

    const functionName = args._.shift()
    const _env_str = args._.join("\n")

    const _env_file = args.reset ? '' : await Deno.readTextFile(`functions/${functionName}/.env`).catch(e => '')
    const _env_ = `${_env_file}\n${_env_str}`
    const _env_parsed = parse(_env_)
    const _env_str_final = stringify(_env_parsed)

    //console.log(_env_parsed, _env_str_final)

    await Deno.writeTextFile(`functions/${functionName}/.env`, _env_str_final);

    const PROJECT_REF = Deno.env.get('PROJECT_REF')
    const DENO_DEPLOY_TOKEN = Deno.env.get("DENO_DEPLOY_TOKEN")
    const DENO_DEPLOY_PROJECT = `${PROJECT_REF}-${functionName}`
    const FUNCTIONS_DOMAIN = Deno.env.get("FUNCTIONS_DOMAIN")

    const envVars = await load({
        envPath: `functions/${functionName}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });

    const denoAPI = DenoAPI.fromToken(DENO_DEPLOY_TOKEN)
    const denoProject = await denoAPI.getProject(DENO_DEPLOY_PROJECT);
    //let cenvs = {}
    denoProject.envVars.forEach(e => {
        if (!envVars[e]) {
            envVars[e] = null
        }
        //cenvs[e] = null
    })
    if (denoProject === null) {

        console.log('denoProject doesnt exists')

    } else {

        const res = await denoAPI.requestJson(`/projects/${denoProject.id}/env`, {
            method: 'PATCH',
            body: envVars
        })

        console.log(`

[Done]
%c
https://${PROJECT_REF}.${FUNCTIONS_DOMAIN}/${functionName}
https://${PROJECT_REF}-${functionName}.${FUNCTIONS_DOMAIN}
        
        %c
${_env_str_final}`, 'color: lime', 'background-color: #222;color:#999')
        // console.log(envVars)
    }

}