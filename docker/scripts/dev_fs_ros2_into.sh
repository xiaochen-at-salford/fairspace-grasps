#!/usr/bin/env bash

DOCKER_USER="${USER}"
DEV_CONTAINER="fairspace_dev_${USER}_DEBUG"

xhost +local:root 1>/dev/null 2>&1
# xhost +local:docker 1>/dev/null 2>&1

docker exec \
    -u "${DOCKER_USER}" \
    -it "${DEV_CONTAINER}" \
    /bin/bash   

xhost -local:root 1>/dev/null 2>&1
# xhost -local:docker 1>/dev/null 2>&1
