import { API as DenoAPI } from "./api_deno.js";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

export default async function _new(args) {
    const functionName = args._.shift()

    if (!functionName) {
        console.log(`Function name required`)
        Deno.exit()
    }

    const PROJECT_REF = Deno.env.get('PROJECT_REF')
    const DENO_DEPLOY_PROJECT = `${PROJECT_REF}-${functionName}`

    const DENO_DEPLOY_TOKEN = Deno.env.get("DENO_DEPLOY_TOKEN")
    const DENO_DEPLOY_ORG = Deno.env.get("DENO_DEPLOY_ORG")

    const denoAPI = DenoAPI.fromToken(DENO_DEPLOY_TOKEN);

    const envVars = await load({
        envPath: `functions/${functionName}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });

    const res = await denoAPI.requestJson('/projects', {
        method: 'POST',
        body: {
            "name": DENO_DEPLOY_PROJECT,
            "organizationId": DENO_DEPLOY_ORG,
            "envVars": envVars
        }
    })

    await Deno.mkdir(`functions/${functionName}`, { recursive: true });

    const func_code = `
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

console.log("Welcome Function")

serve((req) => {

    const data = {
        url: req.url,
        message: Deno.env.toObject(),
    }

    return Response.json(data)
})
    `

    await Deno.writeTextFile(`functions/${functionName}/index.js`, func_code)

    console.log('new func --> ', res)

}