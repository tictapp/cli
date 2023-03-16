# tt - tictapp cli

```
apt update
apt install curl unzip -y
curl -fsSL https://deno.land/install.sh | sh
echo 'export DENO_INSTALL="/root/.deno"' >> ~/.bashrc && echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

```bash
deno install --allow-all --no-check -r -f https://deno.land/x/tictapp/tt.js
```

## Using docker

```bash
tt () {
  docker run \
    --interactive \
    --tty \
    --rm \
    --volume tt-projects:/app \
    --volume tt-deno:/deno-dir \
    --volume $PWD:/tt \
    serebano/tt \
    "$@"
}
```

```

  Usage:   tt [command]

  Description:

    Command line interface for tictapp

  Options:

    -h, --help             - Show this help.                                           
    -V, --version          - Show the version number for this program.                 
    -d, --debug            - Enable debug output.                                      
    -w, --workdir  [path]  - Specify project working directory          (Default: "./")

  Commands:

    login                   - Login to a tictapp account                       
    link                    - Link to a tictapp project                        
    status                  - View current auth status                         
    projects     [command]  - Manage tictapp projects                          
    functions    [command]  - Manage edge functions                            
    completions             - Generate shell completions.                      
    upgrade                 - Upgrade tt executable to latest or given version.

```