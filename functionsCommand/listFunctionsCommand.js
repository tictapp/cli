import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import { Table } from "https://deno.land/x/cliffy@v0.25.7/table/mod.ts";
import { createClient } from "../api_studio.js";
import { selectProject } from "../helpers.js";

export default function listFunctionsCommand() {
    return new Command()
        .name("list")
        .description("List all functions the logged-in user can access.")
        .option("-p, --project [project:string]", "Specify project reference")
        .option("-a, --all", "List all functions from account")

        .action(async (options, ...args) => {
            let project_ref
            if (!options.all) {
                project_ref = Deno.env.get('PROJECT_REF')

                if (options.project)
                    project_ref = options.project === true ? undefined : options.project

                if (!project_ref)
                    project_ref = await selectProject()
            }

            const api = createClient()
            const functions = await api.getFunctions(project_ref)

            if (functions.error) {
                console.log(functions)
                return;
            }

            if (!functions.length) {
                console.log(`   No functions found`)
                return;
            }

            const body = functions.map(fun => ([
                fun.id,
                //fun.project.name,
                fun.name,
                fun.version,
                fun.endpoint,
                fun.verify_jwt,
                //fun.project.organization?.name,
                new Date(fun.updated_at).toLocaleString()
            ]))

            new Table()
                .header([
                    "ID",
                    // "Project", 
                    "Name", "Version", "Endpoint", "Verify JWT",
                    //"Organization", 
                    "Updated"])
                .body(body)
                //.maxColWidth(10)
                .padding(2)
                //.indent(2)
                .border(false)
                .render();

            //console.table(data)

        })
}