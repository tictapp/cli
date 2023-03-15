import { Command } from "../deps.js";
import loginAction from './loginAction.js'

export default function loginCommand() {
    return new Command()
        .name("login")
        .description("Login to a tictapp account")
        .option("-r --reset", "Reset current login data")
        .action(async function (options) {
            return await loginAction(options)
        })
}