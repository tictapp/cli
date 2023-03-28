import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import projectsList from "./list.js";
import projectsNew from "./new.js";
import projectsInfoCommand from "./projectsInfoCommand.js";
import projectsTypesCommand from "./projectsTypesCommand.js";

export default new Command()
    .name("projects")
    .description("Manage tictapp projects")
    .arguments("[command]")
    .action(function (...a) {
        this.showHelp();
        return;
    })
    .command('info', projectsInfoCommand())
    .command('list', projectsList())
    .command('new', projectsNew())
    .command('types', projectsTypesCommand())