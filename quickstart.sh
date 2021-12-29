#!/usr/bin/env bash

PWD=$(pwd)

PORT="$PORT"
if [ -z "$PORT" ]; then
    PORT="8089"
fi

set -eux

docker run --name wolweb-instance \
    -v "${PWD}/devices.json:/devices.json" \
    -v "${PWD}/config.json:/config.json" \
    -p "${PORT}:8089" \
    --restart unless-stopped \
    -d ghcr.io/ahmedalhulaibi/wolweb:latest

docker ps

echo "run the below command to stop the container"

echo "docker stop wolweb-instance"

popd