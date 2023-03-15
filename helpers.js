import { join } from "./deps.js";
import { getVersions } from "./upgrade.js";
import { API as StudioAPI } from "./api_studio.js";
import { Select } from "./deps.js";

export function getConfigPaths() {
    const homeDir = Deno.build.os == "windows"
        ? Deno.env.get("USERPROFILE")
        : Deno.env.get("HOME");
    const configDir = join(homeDir, ".deno", "tictapp");

    return {
        configDir,
        loginPath: join(configDir, "login.json"),
        updatePath: join(configDir, "update.json"),
    };
}

export async function getLogin() {
    const { loginPath, configDir } = getConfigPaths();
    // Try to read the json file.
    const loginInfoJson = await Deno.readTextFile(loginPath).catch((error) => {
        if (error.name == "NotFound") return null;
        console.error(error);
    });

    if (loginInfoJson) {
        return JSON.parse(loginInfoJson)
    }
    return null
}

export async function fetchReleases() {
    try {
        const { latest } = await getVersions();
        const updateInfo = { lastFetched: Date.now(), latest };
        const { updatePath, configDir } = getConfigPaths();
        await Deno.mkdir(configDir, { recursive: true });
        await Deno.writeFile(
            updatePath,
            new TextEncoder().encode(JSON.stringify(updateInfo, null, 2)),
        );
    } catch (_) {
        // We will try again later when the fetch isn't successful,
        // so we shouldn't report errors.
    }
}

export async function getJson(filePath) {
    return JSON.parse(await Deno.readTextFile(filePath));
}

export async function exists(path) {
    try {
        return (await Deno.stat(path)).isFile;
    } catch {
        return false;
    }
}


export async function writeJson(filePath, o) {
    await Deno.writeTextFile(filePath, JSON.stringify(o, null, 4));
}

export async function selectProject() {
    const TOKEN = Deno.env.get('TOKEN')

    const studio_api = StudioAPI.fromToken(TOKEN)
    const studio_projects = await studio_api.requestJson(`/projects`)
    if (studio_projects.error) {
        console.log(studio_projects)
        Deno.exit()
    }
    // console.table(studio_projects.map(o => ({ name: o.name, ref: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })))

    // PROJECT_REF = prompt(`Enter project ref`)
    return await Select.prompt({
        message: "Select project to continue",
        options: studio_projects.map(o => ({ name: `${o.ref} - ${o.name} (${o.status})`, value: o.ref, url: `https://${o.ref}.tictapp.io`, updated: o.updated_at })),
    });
}