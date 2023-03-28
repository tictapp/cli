import { Command } from "../deps.js";
import loginAction from './loginAction.js'
//import { open } from 'https://deno.land/x/open/index.ts';

export default new Command()
    .name("login")
    .description("Login to a tictapp account")
    .option("-r --reset", "Reset current login data")
    .action(async function (options) {

        //await open('https://tictapp.studio/login?cli');

        return await loginAction(options)
    })
