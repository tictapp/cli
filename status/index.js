import { Command, wait } from "../deps.js";
import statusAction from '../status.js'

export default function statusCommand() {
    return new Command()
        .name("status")
        .description("View current auth status")
        .action(async function () {
            return await statusAction()
        })
}