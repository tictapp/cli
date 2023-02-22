import { bold, red } from "./deps.js";

export function printError(message) {
    console.error(red(`${bold("error")}: ${message}`));
}

export function error(message) {
    printError(message);
    Deno.exit(1);
}