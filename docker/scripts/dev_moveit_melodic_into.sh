#!/usr/bin/env bash

DOCKER_USER="${USER}"
DEV_CONTAINER="moveit_melodic_${USER}"

xhost +local:root 1>/dev/null 2>&1
# xhost +local:docker 1>/dev/null 2>&1

docker exec \
    -u "${DOCKER_USER}" \
    -it "${DEV_CONTAINER}" \
    /bin/bash   

# docker exec \
#     -it "${DEV_CONTAINER}" \
#     /bin/bash   

xhost -local:root 1>/dev/null 2>&1
# xhost -local:docker 1>/dev/null 2>&1
