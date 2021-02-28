#!/usr/bin/env bash

# DOCKER_USER="${USER}"
DEV_CONTAINER="fairspace_ros_dev"

# xhost +local:docker 1>/dev/null 2>&1
xhost +local:root 1>/dev/null 2>&1
# xhost +

docker exec \
    -it "${DEV_CONTAINER}" \
    /bin/bash   

xhost -local:docker 1>/dev/null 2>&1
    # -u "${DOCKER_USER}" \
    # -e HISTFILE=/apollo/.dev_bash_hist \
# xhost -local:docker 1>/dev/null 2>&1
xhost -local:root 1>/dev/null 2>&1
# xhost -

    #  -e XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} \