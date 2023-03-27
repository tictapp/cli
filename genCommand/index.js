import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import projectsTypesCommand from "../projectsCommand/projectsTypesCommand.js";
import genEnvCommand from './genEnvCommand.js'
import { ValidationError } from "../deps.js";

export default function projects() {

    return new Command()
        .name("gen")
        .description("Run code generation tools")
        .arguments("[command]")
        .action(function (_, cmd) {
            if (cmd) {
                throw new ValidationError(`Invalid command: "${cmd}"`)
            }
            this.showHelp();
            return;
        })
        .command('types', projectsTypesCommand())
        .command('env', genEnvCommand())

}