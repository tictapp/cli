# tt
## tictapp cli

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

## Install deno
```
apt update
apt install curl unzip -y
curl -fsSL https://deno.land/install.sh | sh
echo 'export DENO_INSTALL="/root/.deno"' >> ~/.bashrc && echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```