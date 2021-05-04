#! /bin/bash

TAG_NAME=$(git describe --tags --abbrev=0)

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..

export DOCKER_BUILDKIT=1
docker build \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  -t ucdlib/jena-fuseki-eb:$TAG_NAME \
  .