import { colors } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";
import { exists, existsSync } from "https://deno.land/std/fs/mod.ts";
import { wait } from "../deps.js";

const error = colors.bold.red;
const warn = colors.bold.yellow;
const info = colors.bold.blue;

const func_code = `
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

console.log("Welcome Function")

serve((req) => {

    const data = {
        url: req.url,
        message: Deno.env.toObject(),
    }

    return Response.json(data)
})
    `

export default async function newFunctionAction(name, options) {
    const functionName = name

    const spinner = wait(`Creating function "${name}"`).start()

    // if (!await exists('./tictapp.json')) {
    //     spinner.fail(`${warn(`No project found. Run tt link`)}`)
    //     return;
    // }

    if (await exists(`functions/${functionName}`)) {
        spinner.fail(`Function ${error(`functions/${functionName}`)} already exists`)
        return;
    }

    await Deno.mkdir(`functions/${functionName}`, { recursive: true });

    await Deno.writeTextFile(`functions/${functionName}/index.js`, func_code)

    spinner.succeed(`Function ${info(`functions/${functionName}`)} created`)
}