#!/usr/bin/env bash

PWD=$(pwd)

WOLWEBPORT="$WOLWEBPORT"
if [ -z "$WOLWEBPORT" ]; then
    WOLWEBPORT="8089"
fi

WOLWEBBCASTIP="$WOLWEBBCASTIP"
if [ -z "$WOLWEBBCASTIP" ]; then
    WOLWEBBCASTIP="192.168.1.255:9"
fi

set -eux

docker run --name wolweb-instance \
    -v "${PWD}/devices.json:/devices.json" \
    -v "${PWD}/config.json:/config.json" \
    -p "${WOLWEBPORT}:8089" \
    -e WOLWEBBCASTIP="${WOLWEBBCASTIP}"
    --restart unless-stopped \
    --network host \
    -d ghcr.io/ahmedalhulaibi/wolweb:latest

docker ps

echo "run the below command to stop the container"

echo "docker stop wolweb-instance"

popd