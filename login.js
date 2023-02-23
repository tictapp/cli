import { getConfigPaths } from './helpers.js'
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";

export default async function _login(args) {
    const { loginPath, configDir } = getConfigPaths();
    // Try to read the json file.
    const loginInfoJson = await Deno.readTextFile(loginPath).catch((error) => {
        if (error.name == "NotFound") return null;
        console.error(error);
    });

    let loginInfo = { token: '', deno_deploy_token: '', deno_deploy_org: '' }

    if (loginInfoJson) {
        loginInfo = JSON.parse(loginInfoJson)
        console.log('loginInfo', loginInfo)
    }

    initLogin(loginInfo)

}

async function initLogin(loginInfo) {
    const { loginPath, configDir } = getConfigPaths();

    //const loginInfo = { token: '', deno_deploy_token: '', deno_deploy_org: '' }

    loginInfo.token = prompt(`Your tictapp access token`, loginInfo.token)
    const api = StudioAPI.fromToken(loginInfo.token)
    const profile = await api.requestJson(`/profile`)

    if (profile.error) {
        console.error(profile.error)
        Deno.exit()
    }

    loginInfo.profile = profile

    console.log(`[ok] ${profile.primary_email}`)

    loginInfo.deno_deploy_token = prompt(`Your deno deploy token`, loginInfo.deno_deploy_token)

    const denoAPI = DenoAPI.fromToken(loginInfo.deno_deploy_token);
    const denoOrgs = await denoAPI.requestJson('/organizations');

    console.table(denoOrgs)

    loginInfo.deno_deploy_org = prompt(`Your deno deploy organization id`, loginInfo.deno_deploy_org)

    const denoOrg = await denoAPI.requestJson(`/organizations/${loginInfo.deno_deploy_org}`);

    console.table(denoOrg.projects.map(p => p.name))

    await Deno.mkdir(configDir, { recursive: true });
    await Deno.writeFile(
        loginPath,
        new TextEncoder().encode(JSON.stringify(loginInfo, null, 2)),
    );
}