#!/usr/bin/env bash

# ROS_DEV_IMAG="xiaochenatsalford/fairspace:fairspace-ros-dev-melodic-ubuntu18.04"
ROS_DEV_IMAG="fairspace-ros-dev-melodic-ubuntu18.04:latest"


source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)/scripts/salford.bashrc"
info "Workspace toplevel dir: ${WS_ROOT}"

CATKIN_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
ROS_DEV_CNTN="fairspace_ros_dev"

check_host_environment() 
{
    info "Expecting a x86_64 Ubuntu-18.04 environment ..."

    local kernel="$(uname -s)"
    if [[ "${kernel}" != "Linux" ]]
    then
        waring "Running ${ROS_DEV_CNTN} on ${kernal} is untested, exiting ..."
        exit 1
    fi

    local arch=$(uname -m)
    if [[ "${arch}" != "x86_64" ]]
    then
        warning "Unsupport target architecture: ${arch}"
    fi  

    local os="$(lsb_release -s -i)-$(lsb_release -s -r)"
    if [[ "${os}" != "Ubuntu-18.04" ]]
    then
        warning : "Running ${ROS_DEV_CNTN} on ${os} is untested, exiting ..."
        exit 1
    fi

    ok "The current host environment: ${arch}-${kernel}-${os}"
}

function remove_existing_ros_dev_container()
{
    if docker ps -a --format '{{.Names}}' | grep -q "${ROS_DEV_CNTN}"
    then
        info "Found an existing \"${ROS_DEV_CNTN}\", remove it .."
        docker stop "${ROS_DEV_CNTN}" >/dev/null
        docker rm -v -f "${ROS_DEV_CNTN}" >/dev/null
    fi
}

function setup_devices_and_mount_local_volumes()
{
    local retval="$1"
    volumes="${volumes} -v /media:/media \
                        -v /tmp/.X11-unix:/tmp/.X11-unix \
                        -v /etc/localtime:/etc/localtime:ro \
                        -v /usr/src:/usr/src \
                        -v /lib/modules:/lib/modules"
    volumes="$(tr -s " " <<< "${volumes}")"
    eval "${retval}='${volumes}'"    
}

function main()
{
    check_host_environment

    info "Check and remove existing "
    remove_existing_ros_dev_container

    local local_volumes=""
    setup_devices_and_mount_local_volumes local_volumes 

    info "Startarting \"${ROS_DEV_CNTN}\""
    set -x
    local display="${DISPLAY:-:0}"    
    local host_name="dev-in-fairspace"
    local local_host="$(hostname)"
    local host_ws_to_docker_ws="-v  ${WS_ROOT}:/home/hhkb/catkin_ws:rw"

    docker run -itd \
        --gpus all \
        --privileged \
        -u hhkb \
        --name "${ROS_DEV_CNTN}" \
        -e DISPLAY="${display}" \
        --network host \
        --add-host "${host_name}:127.0.0.1" \
        --add-host "${local_host}:127.0.0.1" \
        --hostname "${ROS_DEV_CNTN}" \
        --shm-size 1g \
        --hostname "${host_name}" \
        -w /home/hhkb/catkin_ws \
        ${host_ws_to_docker_ws} \
        -v /dev/null:/dev/raw1394 \
        ${local_volumes} \
        "${ROS_DEV_IMAG}" \
        /bin/bash

    if [[ $? -ne 0 ]]
    then
        error "Failed to start docker container \"${ROS_DEV_CNTN}\" based on \"${ROS_DEV_IMAG}\" "
        exit 1
    fi

    ok "You have succesfully started \"${ROS_DEV_CNTN}\"."
}

main