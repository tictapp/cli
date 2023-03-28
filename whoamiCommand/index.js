import { Command, ValidationError } from "../deps.js";
import statusAction from '../status.js'

export default new Command()
    .name("whoami")
    .description("Show the user currently logged into")
    .action(async function () {
        try {
            return await statusAction()
        } catch (e) {
            throw new ValidationError(e)
        }
    })