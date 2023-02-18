#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

async function exists(path) {
    try {
        return (await Deno.stat(path)).isFile;
    } catch {
        return false;
    }
}

async function writeJson(filePath, o) {
    await Deno.writeTextFile(filePath, JSON.stringify(o, null, 4));
}

async function getJson(filePath) {
    return JSON.parse(await Deno.readTextFile(filePath));
}

export default async function status() {
    const json = await getJson(`./tictapp.json`)

    const { profile, project } = json

    console.log(`
%c${profile.primary_email}

%c${project.name}  %c${project.status}%c

Api:        https://${project.endpoint}
Functions:  https://${project.endpoint.replace('.io', '.fun')}
`,
        "color: orange",
        "color: aquamarine;font-weight:bold",
        "background-color: grey",
        `color: blue`,
    );

}