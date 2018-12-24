#!/bin/sh -e

CONTAINER_ID=`docker ps -aqf "name=ngrok"`

rm -rf clients
docker cp  $CONTAINER_ID:/ngrok-backend/bin clients
cp ngrok.cfg clients/ngrok.cfg

echo "Copy clients from container to local clients/"
