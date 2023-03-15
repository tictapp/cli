# tt - tictapp cli

```bash
deno install --allow-all --no-check -r -f https://deno.land/x/tictapp/tt.js
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