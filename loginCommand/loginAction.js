import { selectProject, writeJson, getConfigPaths } from '../helpers.js'
import { API as StudioAPI } from "../api_studio.js";
import { API as DenoAPI } from "../api_deno.js";
import { stringify } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import { prompt, Input, Confirm, Secret, Select, ValidationError, colors } from '../deps.js';


export default async function loginAction(options) {

    const { loginPath, configDir } = getConfigPaths();

    // Try to read the json file.
    const loginInfoJson = await Deno.readTextFile(loginPath).catch((error) => {
        if (error.name == "NotFound") return null;
        console.error(error);
    });

    let loginInfo = { token: '', deno_deploy_token: '' }

    if (loginInfoJson) {
        loginInfo = JSON.parse(loginInfoJson)
        if (loginInfo.profile)
            console.log(colors.dim.italic(`   Current account: ${colors.bold(loginInfo.profile.primary_email)}`))
    }

    if (options.reset) {
        const confirmed = await Confirm.prompt(`Login data will be removed. Are you sure?`);
        if (confirmed) {
            Deno.removeSync(loginPath)
            console.log('Login data removed', loginPath)
        } else {
            console.log('No changes')
        }
        Deno.exit()
    }

    const result = {}

    result.token = await Input.prompt({
        name: "token",
        message: "Your tictapp access token",
        hint: 'You can generate an access token from https://tictapp.studio/account/tokens',
        suggestions: [loginInfo.token],
        validate: async function (token) {
            if (!token) token = loginInfo.token

            const api = StudioAPI.fromToken(token)
            const profile = await api.requestJson(`/profile`)

            if (profile.error) {
                return `${profile.error.message || profile.error}`
            } else {
                result.profile = profile
                return true
            }
        },
        transform: (value) => {
            return value ? value : loginInfo.token
        }
    })

    result.deno_deploy_token = await Input.prompt({
        name: "deno_deploy_token",
        message: "Your deno deploy access token",
        hint: 'You can generate an access token from https://dash.deno.com/account#access-tokens',
        suggestions: [loginInfo.deno_deploy_token],
        validate: async function (token) {
            if (!token) token = loginInfo.deno_deploy_token
            try {
                const denoAPI = DenoAPI.fromToken(token);
                await denoAPI.requestJson('/organizations');

                return true
            } catch (e) {
                return e.message
            }
        },
        transform: (value) => {
            return value ? value : loginInfo.deno_deploy_token
        }
    })

    await Deno.mkdir(configDir, { recursive: true });
    await Deno.writeFile(
        loginPath,
        new TextEncoder().encode(JSON.stringify(result, null, 2)),
    );

    console.log(`
        ${(`Login success (${colors.green.bold(result.profile.primary_email)})`)}
    `)
}