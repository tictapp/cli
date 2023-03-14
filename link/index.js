import { Command } from "../deps.js";
import linkAction from './linkAction.js'

export default function linkCommand() {
    return new Command()
        .name("link")
        .description("Link to a tictapp project")
        .action(async function () {
            return await linkAction()
        })
}