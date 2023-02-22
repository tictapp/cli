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