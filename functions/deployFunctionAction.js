import { colors } from "https://deno.land/x/cliffy@v0.25.7/ansi/mod.ts";
import { selectProject, exists } from "../helpers.js";
import { API as StudioAPI } from "../api_studio.js";
import { load as loadEnv } from "https://deno.land/std@0.177.0/dotenv/mod.ts";
import denoDeployCmd from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/deploy.ts"

const error = colors.bold.red;
const warn = colors.bold.yellow;
const info = colors.bold.blue;

export default async function deployFunctionAction(name, options) {
    const func_slug = name

    let func_path = `./functions/${func_slug}`

    if (!options.root) {
        Deno.chdir(func_path)
        func_path = '.'
    } else {
        Deno.chdir('./functions')
        func_path = `./${func_slug}`
    }

    //console.log(`Working Directory`, Deno.cwd())

    let project_ref = Deno.env.get('PROJECT_REF')

    if (options.project)
        project_ref = options.project === true ? undefined : options.project

    if (!project_ref)
        project_ref = await selectProject()

    // const spinner = wait(`Checking function "${func_slug}"...`).start()

    const studioAPI = StudioAPI.fromToken(Deno.env.get('TOKEN'))
    //const func = await studioAPI.requestJson(`/admin/projects/${project_ref}/functions/${func_slug}`)

    const envVars = await loadEnv({
        envPath: `${func_path}/.env`,
        defaultsPath: `.env.defaults`,
        export: false
    });


    const newFunc = await studioAPI.requestJson(`/admin/projects/${project_ref}/functions`, {
        method: 'POST',
        body: {
            name: func_slug,
            verify_jwt: options.verifyJwt,
            import_map: options.importMap,
            envVars
        }
    })


    let entrypoint = `${func_path}/index.js`
    if (!(await exists(entrypoint)))
        entrypoint = `${func_path}/index.ts`

    if (!(await exists(entrypoint)))
        entrypoint = `${func_path}/main.ts`
    if (!(await exists(entrypoint)))
        entrypoint = `${func_path}/main.js`

    if (!(await exists(entrypoint))) {
        console.error(warn(`Entrypoint failed: ${entrypoint}`))
        // spinner.fail(`Entrypoint failed: ${entrypoint}`)
        Deno.exit()
    }

    const deployArgs = {
        token: Deno.env.get("DENO_DEPLOY_TOKEN"),
        project: `${project_ref}-${func_slug}`,
        prod: true,
        static: true,
        //static: args.static,
        //include: functionName,
        _: [entrypoint]
    }

    if (await exists(`${func_path}/import_map.json`))
        deployArgs["import-map"] = `${func_path}/import_map.json`

    await denoDeployCmd(deployArgs)


    //console.log(deployArgs)

    //console.log('options', newFunc, options, project_ref)

    console.log(`Function ${info(`${func_slug}`)} deployed at ${info(`${newFunc.endpoint}`)}`)

}