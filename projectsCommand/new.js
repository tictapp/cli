import {
    Command,
    Input,
    Select,
    prompt,
    generatePassword,
    wait
} from "../deps.js";

import { createClient } from "../api_studio.js";

export default function projectsNew() {
    return new Command()
        .name("new")
        .description("Create new project")
        .arguments('<name:string>')
        .action(async (options, name) => {
            //console.log("Create new project called", name)


            const accountSpinner = wait("Fetching account information...").start();

            const api = createClient()
            const organizations = await api.getOrganizations()

            if (organizations.error) {
                accountSpinner.fail(organizations.error.message)
                throw new Error(organizations.error.message);
            }

            accountSpinner.stop()

            const result = await prompt([{
                name: "organization_id",
                message: "Select organization",
                type: Select,
                options: organizations.map(org => ({ name: org.name, value: String(org.id) }))
            }, {
                name: "db_pass",
                message: "Database password",
                type: Input,
                default: generatePassword(20, true, false)
            }]);

            result.name = name
            result.organization_id = Number(result.organization_id)

            //console.log('result', result)

            const projectSpinner = wait("Creating your project...").start();

            const project = await api.createProject({
                ...result
            })

            if (project.error) {
                accountSpinner.fail(project.error.message)
                throw new Error(project.error.message);
            }

            projectSpinner.succeed(`Project "${project.name}" has been created. https://tictapp.studio/project/${project.ref}`)
        })
}