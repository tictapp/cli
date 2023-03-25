import { Command } from "https://deno.land/x/cliffy@v0.25.7/command/mod.ts";
import projectsList from "./list.js";
import projectsNew from "./new.js";
import projectsInfoCommand from "./projectsInfoCommand.js";

export default function projects() {

    return new Command()
        .name("projects")
        .description("Manage tictapp projects")
        .arguments("[command]")
        .action(function (...a) {
            console.log('action', a)
            this.showHelp();
            return;
        })
        .command('info', projectsInfoCommand())
        .command('list', projectsList())
        .command('new', projectsNew())

}