import { selectProject, writeJson } from '../helpers.js'
import { API as StudioAPI } from "../api_studio.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

const configFile = `tictapp.json`

export default async function linkAction() {
    const project_ref = await selectProject()

    console.log(`project_ref`, project_ref)

    const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
    const project = await studioAPI.getProject(project_ref, true)

    const config = {
        project: {
            ref: project.ref,
            id: project.id,
            endpoint: project.endpoint,
        }
    }

    await writeJson(`./${configFile}`, config)

    const defaultEnvVars = {
        "SUPABASE_REF": project.ref,
        "SUPABASE_URL": `https://${project.endpoint}`,
        "SUPABASE_ANON_KEY": project.anon_key,
        "SUPABASE_SERVICE_KEY": project.service_key,
        "JWT_SECRET": project.jwt_secret,
        "VERIFY_JWT": String(false)
    }

    await Deno.writeTextFile(`./.env.defaults`, stringify(defaultEnvVars));

    console.log(`project`, config)

}