#!/bin/sh
set -e

# if [ "$1" != "${1#-}" ]; then
#     # if the first argument is an option like `--help` or `-h`
#     #exec deno run --allow-read --allow-write --allow-net --allow-env --allow-run --no-config "./tt.js" "$@"
#     exec deno run --allow-all --no-config 'https://deno.land/x/tictapp/tt.js' "$@"
# fi

# case "$1" in
#     bench | bundle | cache | compile | completions | coverage | doc | eval | fmt | help | info | install | lint | lsp | repl | run | task | test | types | uninstall | upgrade | vendor )
#     # if the first argument is a known deno command
#     exec deno "$@";;
# esac

#exec deno run --allow-read --allow-write --allow-net --allow-env --allow-run --no-config "./tt.js" "$@"

exec deno run --allow-all --no-config 'https://deno.land/x/tictapp/tt.js' "$@"
#exec deno run --allow-all --no-config '/tt/tt.js' "$@"
