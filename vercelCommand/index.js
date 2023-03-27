import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import { ValidationError, colors } from "../deps.js";
import { load } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { Table } from "../deps.js";
import { timeAgo } from "https://deno.land/x/time_ago/mod.ts";

function _action(_, cmd) {
    if (cmd) {
        throw new ValidationError(`Invalid command: "${cmd}"`)
    }
    this.showHelp();
    return;
}

async function getProjectEnvs(project_id, opts) {
    const VERCEL_TOKEN = Deno.env.get("VERCEL_ACCESS_TOKEN")

    const url = new URL(`https://api.vercel.com/v9/projects/${project_id}/env`)
    if (opts.decrypt)
        url.searchParams.set("decrypt", true)

    if (opts.branch)
        url.searchParams.set("gitBranch", opts.branch)


    const res = await fetch(url, {
        headers: {
            Authorization: `Bearer ${VERCEL_TOKEN}`,
        },
        "method": "get"
    })

    const result = await res.json()

    return result
}

export default function vercel() {

    return new Command()
        .name("vercel")
        .description("Vercel management api")
        .arguments("[command]")
        .action(_action)
        .command('projects', new Command()
            .description("Get projects")
            .action(async () => {
                const res = await fetch(
                    'https://api.vercel.com/v6/projects',
                    {
                        method: 'GET',
                        headers: {
                            Authorization: `Bearer ${Deno.env.get("VERCEL_ACCESS_TOKEN")}`,
                        }
                    }
                );
                const result = await res.json()
                //console.log(result)
                const projects = result.projects.map(({ name, link, latestDeployments, updatedAt }) => {
                    const deployments = latestDeployments.map(({ url, target, alias }) => {
                        return {
                            url,
                            target,
                            alias
                        }
                    })
                    const latestDeployment = deployments.shift()

                    return [
                        colors.bold(name),
                        `https://${latestDeployment.alias[0]}`,
                        //target: latestDeployment.target,
                        link ? `${link?.type}/${link?.org}/${link?.repo}` : `(unlinked)`,
                        timeAgo(new Date(updatedAt))
                    ]
                })
                console.log("\n")
                new Table()
                    .indent(3)
                    .header([colors.blue.bold("Name"), colors.blue.bold("Latest production url"), colors.blue.bold("Link"), colors.blue.bold("Updated")])
                    .body(projects)
                    .render();
                console.log("\n")
            })
        )
        .command('deployments', new Command()
            .description("Get deployments")
            .action(async () => {
                const res = await fetch(
                    'https://api.vercel.com/v6/deployments',
                    {
                        method: 'GET',
                        headers: {
                            Authorization: `Bearer ${Deno.env.get("VERCEL_ACCESS_TOKEN")}`,
                        }
                    }
                );
                const result = await res.json()
                console.log('result', result.deployments.map(({ name, url }) => ({ name, url })))
            })
        )
        .command('domains', new Command()
            .description("Manage vercel domains")
            .arguments("<command>")
            .action(_action)
            .command("list",
                new Command()
                    .description("List domains")
                    .alias('ls')
                    .option("-p, --project [string]", "Project name or id")
                    .action(async (opts) => {
                        const VERCEL_TOKEN = Deno.env.get("VERCEL_ACCESS_TOKEN")
                        let project_id

                        try {
                            if (opts.project) {
                                project_id = opts.project
                            } else {
                                project_id = (await import(Deno.cwd() + "/.vercel/project.json", {
                                    assert: { type: "json" },
                                }))?.default?.projectId;
                            }

                            const res = await fetch(`https://api.vercel.com/v9/projects/${project_id}/domains`, {
                                headers: {
                                    Authorization: `Bearer ${VERCEL_TOKEN}`,
                                },
                                "method": "get"
                            })
                            const result = await res.json()
                            if (result.error) {
                                throw new ValidationError(result.error.message)
                            }
                            console.log("Found", result.pagination.count, "domains")
                            console.table(result.domains.map(({ name, verified, redirect, gitBranch }) => ({ name, verified, redirect, gitBranch })))
                        } catch (e) {
                            throw new ValidationError(e.message)
                        }
                    })
            )
            .command("add",
                new Command()
                    .description("Add domain")
                    .arguments("<domain:string>")
                    .option("-p, --project [name:string]", "Project name or id")
                    .option("-r, --redirect [domain:string]", "Set redirect domain")
                    .option("-b, --branch [name:string]", "Assign to specific git branch")
                    .action(async ({ redirect, branch, project }, domain_name) => {
                        const VERCEL_TOKEN = Deno.env.get("VERCEL_ACCESS_TOKEN")

                        let project_id

                        try {
                            if (project) {
                                project_id = project
                            } else {
                                project_id = (await import(Deno.cwd() + "/.vercel/project.json", {
                                    assert: { type: "json" },
                                }))?.default?.projectId;
                            }
                            const res = await fetch(`https://api.vercel.com/v9/projects/${project_id}/domains`, {
                                body: JSON.stringify({
                                    name: domain_name,
                                    redirect: redirect,
                                    gitBranch: branch
                                }),
                                headers: {
                                    Authorization: `Bearer ${VERCEL_TOKEN}`,
                                },
                                method: "POST"
                            })

                            if (res.status !== 200) {
                                throw new ValidationError(res.status + " - " + res.statusText)
                            }

                            const result = await res.json()
                            console.table([result].map(({ name, verified, redirect, gitBranch }) => ({ name, verified, redirect, gitBranch })))

                            //console.log('result', result)

                        } catch (e) {
                            throw new ValidationError(e.message)
                        }
                    })
            )
        )
        .command('env', new Command()
            .description("Manage environment variables")
            .arguments("<command>")
            .action(_action)
            .command("list",
                new Command()
                    .description("List env")
                    .alias('ls')
                    .option("-p, --project [string]", "Project name or id")
                    .option("-b, --branch [string]", "The git branch of the environment variable to filter the results")
                    //.option("--decrypt [boolean]", "Return decrypted value")
                    .action(async (opts) => {
                        console.log(opts)
                        const VERCEL_TOKEN = Deno.env.get("VERCEL_ACCESS_TOKEN")
                        let project_id
                        try {
                            if (opts.project) {
                                project_id = opts.project
                            } else {
                                project_id = (await import(Deno.cwd() + "/.vercel/project.json", {
                                    assert: { type: "json" },
                                }))?.default?.projectId;
                            }

                            const result = await getProjectEnvs(project_id, opts)

                            if (result.error) {
                                throw new ValidationError(result.error.message)
                            }
                            //console.log(result)
                            console.table(result.envs.map(({ key, type, id, target }) => ({ key, type, id, target: target.join(", ") })))
                        } catch (e) {
                            throw new ValidationError(e.message)
                        }
                    })
            )
            .command("add",
                new Command()
                    .description("Create one or more environment variables")
                    .arguments("<envfile:file>")
                    .option("-p, --project [name:string]", "Project name or id")
                    .option("-b, --branch [string]", "The git branch of the environment variable to filter the results")
                    .action(async ({ project, branch }, envfile) => {
                        const VERCEL_TOKEN = Deno.env.get("VERCEL_ACCESS_TOKEN")
                        let project_id

                        try {
                            if (project) {
                                project_id = project
                            } else {
                                project_id = (await import(Deno.cwd() + "/.vercel/project.json", {
                                    assert: { type: "json" },
                                }))?.default?.projectId;
                            }

                            const envObj = await load({
                                envPath: envfile,
                                export: false
                            });

                            const envs = Object.keys(envObj).map(key => {
                                return {
                                    key,
                                    value: envObj[key],
                                    type: "plain",
                                    target: ["production", "development", "preview"]
                                }
                            })

                            const { envs: existingEnvs } = await getProjectEnvs(project_id, { branch })

                            const deletedEnvs = await Promise.all(existingEnvs.map(async ({ id }) => {
                                return await (await fetch(`https://api.vercel.com/v9/projects/${project_id}/env/${id}`, {
                                    headers: {
                                        Authorization: `Bearer ${VERCEL_TOKEN}`,
                                    },
                                    method: "DELETE"
                                })).json()
                            }))

                            console.log("deletedEnvs", deletedEnvs)

                            const url = new URL(`https://api.vercel.com/v9/projects/${project_id}/env`)
                            url.searchParams.set("upsert", false)

                            console.log('url', url)

                            const res = await fetch(url, {
                                body: JSON.stringify(envs),
                                headers: {
                                    Authorization: `Bearer ${VERCEL_TOKEN}`,
                                },
                                method: "POST"
                            })

                            const result = await res.json()

                            if (result.error) {
                                //console.error(result)
                                throw new ValidationError(result.error.key + " - " + result.error.message)
                            }

                            if (res.status !== 200) {
                                //console.error(result)
                                throw new ValidationError(res.status + " - " + res.statusText)
                            }

                            console.log('result', result)

                            //console.table([result].map(({ name, verified, redirect, gitBranch }) => ({ name, verified, redirect, gitBranch })))

                            //console.log('result', result)

                        } catch (e) {
                            throw new ValidationError(e.message)
                        }
                    })
            )
        )
}