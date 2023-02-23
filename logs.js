#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-net --allow-run --no-check

import logs from "https://raw.githubusercontent.com/denoland/deployctl/main/src/subcommands/logs.ts"

export default async function _logs(args) {
    const fun_name = args._.shift()

    console.log('args', args)

    await logs({
        //token: args.token,
        prod: args.prod,
        project: `${Deno.env.get('PROJECT_REF')}-${fun_name}`,
        _: []
    })
}