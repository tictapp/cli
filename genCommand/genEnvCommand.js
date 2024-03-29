import { selectProject } from "../helpers.js";
import { API as StudioAPI } from "../api_studio.js";
import { colors, Command, ValidationError } from '../deps.js'
import { load, parse, stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";

export default function genEnvCommand() {
    return new Command()
        .name("env")
        .description("Generate .env file")
        .arguments("<file>", "Path to .env file")
        .option('-p, --project <string>', 'Project reference')
        .action(async (options, filepath) => {

            try {
                let project_ref = Deno.env.get('PROJECT_REF')

                if (options.project)
                    project_ref = options.project === true ? undefined : options.project

                if (!project_ref)
                    project_ref = await selectProject()

                const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
                const project = await studioAPI.getProject(project_ref, true)

                const envObj = {
                    PUBLIC_SUPABASE_REF: project.ref,
                    PUBLIC_SUPABASE_STUDIO: `https://${project.endpoint.replace(".io", ".studio")}`,
                    PUBLIC_SUPABASE_URL: `https://${project.endpoint}`,
                    PUBLIC_SUPABASE_ANON_KEY: project.anon_key,
                    SUPABASE_SERVICE_KEY: project.service_key
                }

                Deno.writeTextFileSync(filepath, stringify(envObj))
                Deno.writeTextFileSync(filepath + ".json", JSON.stringify(envObj, null, 4))

                const envLines = Object.keys(envObj).map(key => {
                    return `vercel env add ${key} production < ${filepath};`
                })

                Deno.writeTextFileSync(filepath + ".sh", envLines.join("\n"))
                Deno.chmod(filepath + ".sh", "0o777")


                console.log(filepath, envObj)

            } catch (e) {
                throw new ValidationError(`${e}`)
            }

        })
}