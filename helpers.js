import { join } from "./deps.js";
import { getVersions } from "./upgrade.js";

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