import { Command } from "../deps.js";
import linkAction from './linkAction.js'

export default new Command()
    .name("link")
    .alias("ln")
    .description("Link to a tictapp project")
    .action(async function () {
        return await linkAction()
    })