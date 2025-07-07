#!/bin/bash


DOCKER_USERNAME=${DOCKERHUB_USERNAME}
APP_NAME=assu-app
TAG=latest

BLUE_CONTAINER="assu-blue"
GREEN_CONTAINER="assu-green"
COMPOSE_FILE="/home/ubuntu/app/docker-compose.yml"
COMPOSE_PATH="/home/ubuntu/app"

echo "[1] Determine currently running container"
ACTIVE_CONTAINER=$(docker ps --filter "name=assu-" --format "{{.Names}}" | grep assu- | head -n 1)

if [ "$ACTIVE_CONTAINER" == "$BLUE_CONTAINER" ]; then
  NEW_CONTAINER=$GREEN_CONTAINER
  OLD_CONTAINER=$BLUE_CONTAINER
  NEW_PORT=8081
else
  NEW_CONTAINER=$BLUE_CONTAINER
  OLD_CONTAINER=$GREEN_CONTAINER
  NEW_PORT=8080
fi

echo "[2] Pull latest Docker image"
docker pull $DOCKER_USERNAME/$APP_NAME:$TAG

echo "[3] Stop and remove old container if exists: $OLD_CONTAINER"
docker stop $OLD_CONTAINER || true
docker rm $OLD_CONTAINER || true

echo "[4] Start new container: $NEW_CONTAINER"
docker compose -f $COMPOSE_FILE up -d $NEW_CONTAINER

echo "[5] Wait for container to start (basic health delay)"
sleep 10

echo "[✅] $NEW_CONTAINER deployed on port $NEW_PORT"