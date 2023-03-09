import { getJson, exists, getLogin } from "./helpers.js";
import { API as StudioAPI } from "./api_studio.js";
import { API as DenoAPI } from "./api_deno.js";
import { wait } from "./deps.js";

export default async function status() {
    const FUNCTIONS_DOMAIN = Deno.env.get("FUNCTIONS_DOMAIN")

    const spinner = wait(`Fetching account information`).start()

    const login = await getLogin()

    if (login) {
        //console.log(login)

        const studio_api = StudioAPI.fromToken(login.token)
        const deno_api = DenoAPI.fromToken(login.deno_deploy_token)

        const studio_profile = await studio_api.requestJson(`/projects`)
        const deno_profile = await deno_api.requestJson(`/projects`)

        // console.log(` - ${studio_profile.length} Project`)
        // console.log(` - ${deno_profile.length} Functions`)

        spinner.succeed(`${login.profile.primary_email} (${studio_profile.length} Projects, ${deno_profile.length} Functions)`)

        //console.log(studio_profile, deno_profile)
    } else {
        spinner.warn(`No auth info found`)
    }

    // if (!await exists('./tictapp.json')) {
    //     console.log(`No project found. run tictapp init`)
    //     Deno.exit()
    // }


    //     const json = await getJson(`./tictapp.json`)

    //     const { profile, project } = json

    //     console.log(`
    // %c${profile.primary_email}

    // %c${project.name}  %c${project.status}%c

    // Api:        https://${project.endpoint}
    // Functions:  https://${project.ref}.${FUNCTIONS_DOMAIN}
    // `,
    //         "color: orange",
    //         "color: aquamarine;font-weight:bold",
    //         "background-color: grey",
    //         `color: blue`,
    //     );

}