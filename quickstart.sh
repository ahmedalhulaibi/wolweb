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

wget https://raw.githubusercontent.com/ahmedalhulaibi/wolweb/main/config.json
wget https://raw.githubusercontent.com/ahmedalhulaibi/wolweb/main/devices.json

docker rm -f wolweb-instance
docker image rm -f ghcr.io/ahmedalhulaibi/wolweb:latest

docker run --name wolweb-instance \
    -v "${PWD}/devices.json:/devices.json" \
    -v "${PWD}/config.json:/config.json" \
    -e WOLWEBPORT="${WOLWEBPORT}" \
    -e WOLWEBBCASTIP="${WOLWEBBCASTIP}" \
    --restart unless-stopped \
    --network host \
    -d ghcr.io/ahmedalhulaibi/wolweb:latest

docker ps

docker logs wolweb-instance

echo "run the below command to stop the container"

echo "docker stop wolweb-instance"
