#!/usr/bin/env bash

CATKIN_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
source "${CATKIN_ROOT_DIR}/scripts/salford.bashrc"

ROS_MASTER_IMAG="ros:melodic-ros-core-bionic"
ROS_MASTER_CNTN="ros_master"

function remove_existing_ros_master()
{
    if docker ps -a --format '{{.Names}}' | grep -q "${ROS_MASTER_CNTN}"
    then
        info "Found an existing \"${ROS_MASTER_CNTN}\", remove it .."
        docker stop "${ROS_MASTER_CNTN}" >/dev/null
    fi
}

function main() 
{
    info "Check and remove existing \"${ROS_MASTER_CNTN}\" ..."
    remove_existing_ros_master

    info "Start \"${ROS_MASTER_CNTN}\" ..."

    local local_host="$(local_host)"

    set -x 
    docker run -itd \
        --rm \
        --name "${ROS_MASTER_CNTN}" \
        --net host \
        --shm-size 1g \
        --add-host "${ROS_MASTER_CNTN}:127.0.0.1" \
        --add-host "${local_host}:127.0.0.1" \
        --hostname "${ROS_MASTER_CNTN}" \
        "${ROS_MASTER_IMAG}" \
        roscore

    if [[ $? -ne 0 ]]
    then
        error "Failed to start docker container \"${ROS_MASTER_CNTN}\" based on \"${ROS_MASTER_IMAG}\""
        exit 1
    fi

    ok "You have succesfully started \"${ROS_MASTER_CNTN}\"."
}

main