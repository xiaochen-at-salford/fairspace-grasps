#!/usr/bin/env bash

# DEV_CONTAINER="osrf-ros2-foxy-desktop"
DEV_CONTAINER="fairspace_ros_dev"

# xhost +local:root 1>/dev/null 2>&1
xhost +local:docker 1>/dev/null 2>&1

docker exec \
    -it "${DEV_CONTAINER}" \
    /bin/bash   

xhost -local:root 1>/dev/null 2>&1
# xhost -local:docker 1>/dev/null 2>&1
