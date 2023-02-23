import { exists } from "./helpers.js"

let version = 0
if (await exists('.version'))
    version = await Deno.readTextFile(".version")

export const VERSION = version //'0.0.0-automated'