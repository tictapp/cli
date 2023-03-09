import { Command } from "../deps.js"
import newFunctionCommand from "./newFunctionCommand.js";

export default function functionsCommand() {
    return new Command()
        .name('fun')
        .description(`Manage edge functions`)
        .arguments("[command]")
        .action(function () {
            this.showHelp();
            return;
        })
        .command('new', newFunctionCommand())
}