import { API as DenoAPI } from "./api_deno.js";

export default async function _delete(args) {
    const functionName = args._.shift()

    if (!functionName) {
        console.log(`Function name required`)
        Deno.exit()
    }

    const PROJECT_REF = Deno.env.get('PROJECT_REF')
    const DENO_DEPLOY_PROJECT = `${PROJECT_REF}-${functionName}`

    const DENO_DEPLOY_TOKEN = Deno.env.get("DENO_DEPLOY_TOKEN")

    const denoAPI = DenoAPI.fromToken(DENO_DEPLOY_TOKEN);
    const denoProject = await denoAPI.getProject(DENO_DEPLOY_PROJECT);

    if (denoProject === null) {

        console.log('Function doesnt exists')

    } else {

        await denoAPI.requestJson(`/projects/${denoProject.id}`, {
            method: 'DELETE'
        })

        await Deno.remove(`functions/${functionName}`, { recursive: true });

        console.log(`Function ${functionName} deleted`)
    }
}