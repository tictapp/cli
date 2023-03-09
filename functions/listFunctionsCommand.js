import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import { Table } from "https://deno.land/x/cliffy@v0.25.7/table/mod.ts";
import { createClient } from "../api_studio.js";

export default function listFunctionsCommand() {
    return new Command()
        .name("list")
        .description("List all functions the logged-in user can access.")
        .action(async (options, ...args) => {

            const api = createClient()
            const functions = await api.getFunctions()

            if (functions.error) {
                console.log(functions)
                return;
            }

            const body = functions.map(fun => ([
                fun.id,
                fun.project.name,
                fun.name,
                fun.version,
                fun.endpoint,
                fun.project.organization?.name,
                new Date(fun.updated_at).toLocaleString()
            ]))

            new Table()
                .header(["ID", "Project", "Name", "Version", "Endpoint", "Organization", "Updated"])
                .body(body)
                //.maxColWidth(10)
                .padding(2)
                //.indent(2)
                .border(false)
                .render();

            //console.table(data)

        })
}