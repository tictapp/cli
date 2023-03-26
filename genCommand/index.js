import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import projectsTypesCommand from "../projectsCommand/projectsTypesCommand.js";
import genEnvCommand from './genEnvCommand.js'

export default function projects() {

    return new Command()
        .name("gen")
        .description("Generator helper")
        .arguments("[command]")
        .action(function (_, cmd) {
            console.log('gen -> ', cmd)
            this.showHelp();
            return;
        })
        .command('types', projectsTypesCommand())
        .command('env', genEnvCommand())

}