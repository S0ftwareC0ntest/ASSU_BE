#!/bin/bash

APP_NAME=assu-app
TAG=latest
DOCKER_USERNAME=${DOCKERHUB_USERNAME:-your_dockerhub_username}

BLUE_CONTAINER="assu-blue"
GREEN_CONTAINER="assu-green"

echo "[1] Determine currently running container"
ACTIVE_CONTAINER=$(docker ps --filter "name=assu-" --format "{{.Names}}" | grep assu- | head -n 1)

if [ "$ACTIVE_CONTAINER" == "$BLUE_CONTAINER" ]; then
  NEW_CONTAINER=$GREEN_CONTAINER
  OLD_CONTAINER=$BLUE_CONTAINER
else
  NEW_CONTAINER=$BLUE_CONTAINER
  OLD_CONTAINER=$GREEN_CONTAINER
fi

echo "[2] Pull latest image"
docker pull $DOCKER_USERNAME/$APP_NAME:$TAG

echo "[3] Run new container: $NEW_CONTAINER"
docker run -d --name $NEW_CONTAINER -p 8080:8080 $DOCKER_USERNAME/$APP_NAME:$TAG

echo "[4] Wait for new container to start (basic health delay)"
sleep 10

echo "[5] Stop and remove old container: $OLD_CONTAINER"
docker stop $OLD_CONTAINER || true
docker rm $OLD_CONTAINER || true

echo "[✅] Switched to $NEW_CONTAINER"
