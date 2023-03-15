#!/bin/sh

docker buildx build -t serebano/tt . && docker push serebano/tt

ttd () {
  docker run \
    --interactive \
    --tty \
    --rm \
    --volume $PWD:/app \
    --volume $HOME/.tictapp:/deno-dir \
    --workdir /app \
    serebano/tt \
    "$@"
}

export ttd