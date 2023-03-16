import { Command, Table, ValidationError } from "../deps.js";
import { createClient } from "../api_studio.js";

export default function projectsList() {
    return new Command()
        .name("list")
        .description("List all tictapp projects the logged-in user can access.")
        .action(async (options, ...args) => {

            try {
                const api = createClient()
                const projects = await api.getProjects()

                if (projects.error) {
                    console.log(projects)
                    return;
                }

                const body = projects.map(project => ([
                    project.id,
                    project.ref,
                    project.name,
                    project.organization.name,
                    project.endpoint,
                    project.status,
                    new Date(project.updated_at).toLocaleString()
                ]))

                new Table()
                    .header(["ID", "Ref", "Name", "Organization", "Endpoint", "Status", "Updated"])
                    .body(body)
                    //.maxColWidth(10)
                    .padding(2)
                    //.indent(2)
                    .border(false)
                    .render();

                //console.table(data)

            } catch (e) {
                throw new ValidationError(e)
            }

        })
}