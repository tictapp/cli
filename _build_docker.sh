#!/bin/sh

docker buildx build -t serebano/tt . && docker push serebano/tt

ttd () {
  docker run \
    --interactive \
    --tty \
    --rm \
    --volume $PWD:/app \
    --volume deno-dir:/deno-dir \
    --workdir /app/examples/14mar \
    serebano/tt \
    "$@"
}

tt2 () {
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

tt3 () {
  docker run \
    --interactive \
    --tty \
    --rm \
    --volume $PWD/examples/tt3:/app \
    --volume tt-deno:/deno-dir \
    --volume $PWD:/tt \
    serebano/tt \
    "$@"
}