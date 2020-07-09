#!/bin/bash

KSP_HOME=${KSP_HOME:-/home/$USER/games/ksp}

TAG=${TAG:-latest}
NAME=${NAME:-michionlion/kerbal-ckan}

IMAGE=${IMAGE:-$NAME:$TAG}

echo "\$TAG=$TAG"
echo "\$NAME=$NAME"
echo "\$IMAGE=$IMAGE"

echo ""
echo ">>> Building..."
docker build --tag "$IMAGE" .

if [[ "$1" == *run ]]; then
  echo ""
  echo ">>> Running..."
  docker run --rm -it \
    --mount type=bind,source="$KSP_HOME",target=/kerbal \
    "$IMAGE"
fi
