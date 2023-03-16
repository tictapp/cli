import {
    Command
} from "../deps.js";
import deployFunctionAction from './deployFunctionAction.js'
import { selectProject } from "../helpers.js";

export default function deployFunctionCommand() {
    return new Command()
        .name("deploy")
        .description("Deploy function")
        .arguments('<name:string>')
        .option("-p, --project [project:string]", "Specify project reference")
        .option("-j, --verify-jwt", "Enable jwt verification")
        .option("-r, --root", "Deploy entire functions folder")
        .option("--import-map", "Import map")
        .action(async (options, name) => {
            await deployFunctionAction(name, options)
        })
}