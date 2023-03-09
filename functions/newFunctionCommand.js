import {
    Command
} from "../deps.js";
import newFunctionAction from './newFunctionAction.js'

export default function newFunctionCommand() {
    return new Command()
        .name("new")
        .description("Create new function")
        .arguments('<name:string>')
        .option("-j, --verify-jwt", "Enable jwt auth")
        .action(async (options, name) => {
            await newFunctionAction(name)
        })
}