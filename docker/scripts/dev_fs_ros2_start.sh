#!/usr/bin/env bash

# ROS_DEV_IMAG="xiaochenatsalford/fairspace:fairspace-ros-dev-melodic-ubuntu18.04"
# FAIRSPACE_DEV_IMAG="ros2-foxy-rviz-test:latest"
FAIRSPACE_DEV_IMAG="fairspace-ros2-foxy-rviz-nvidia:latest"
# FAIRSPACE_DEV_IMAG="fairspace-ros-dev-melodic-ubuntu18.04:latest"
DEV_INSIDE="in-dev-docker"

FAIRSPACE_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
source "${FAIRSPACE_ROOT_DIR}/scripts/fairspace.bashrc"

FAIRSPACE_DEV="fairspace_dev_${USER}"
# source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)/scripts/salford.bashrc"

info "Workspace toplevel dir: ${WS_ROOT}"

# ROS_DEV_CNTN="fairspace_ros_dev"

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

function show_usage() 
{
    cat <<EOF
Usage: $0 [options] ...
OPTIONS:
    -h, --help             Display this help and exit.
    -f, --fast             Fast mode without pulling all map volumes.
    -l, --local            Use local docker image.
    -t, --tag <TAG>        Specify docker image with tag <TAG> to start.
    -d, --dist             Specify Apollo distribution(stable/testing)
    --shm-size <bytes>     Size of /dev/shm . Passed directly to "docker run"
    stop                   Stop all running Apollo containers.
EOF
}

function stop_all_apollo_containers_for_user() 
{
    local force="$1"
    local running_containers
    running_containers="$(docker ps -a --format '{{.Names}}')"
    for container in ${running_containers[*]}; 
    do
        if [[ "${container}" =~ fairspace_.*_${USER} ]]; then
            #printf %-*s 70 "Now stop container: ${container} ..."
            #printf "\033[32m[DONE]\033[0m\n"
            #printf "\033[31m[FAILED]\033[0m\n"
            info "Now stop container ${container} ..."
            if docker stop "${container}" >/dev/null; 
            then
                if [[ "${force}" == "-f" || "${force}" == "--force" ]]; 
                then
                    docker rm -f "${container}" >/dev/null
                fi
                info "Done."
            else
                warning "Failed."
            fi
        fi
    done

    if [[ "${force}" == "-f" || "${force}" == "--force" ]]; 
    then
        info "OK. Done stop and removal"
    else
        info "OK. Done stop."
    fi
}

function parse_arguments() 
{
    local custom_version=""
    local custom_dist=""
    local shm_size=""
    local geo=""

    while [ $# -gt 0 ]; 
    do
        local opt="$1"
        shift
        case "${opt}" in
            -d | --dist)
                custom_dist="$1"
                shift
                _optarg_check_for_opt "${opt}" "${custom_dist}"
                ;;

            -h | --help)
                show_usage
                exit 1
                ;;

            -f | --fast)
                FAST_MODE="yes"
                ;;

            -g | --geo)
                geo="$1"
                shift
                _optarg_check_for_opt "${opt}" "${geo}"
                ;;

            -l | --local)
                USE_LOCAL_IMAGE=1
                ;;

            --shm-size)
                shm_size="$1"
                shift
                _optarg_check_for_opt "${opt}" "${shm_size}"
                ;;


            stop)
                stop_all_apollo_containers_for_user "-f"
                exit 0
                ;;
            *)
                warning "Unknown option: ${opt}"
                exit 2
                ;;
        esac
    done # End while loop
}

function mount_local_volumes()
{
    local retval="$1"

    source "${FAIRSPACE_ROOT_DIR}/scripts/fairspace_base.sh"

    local volumes="-v ${FAIRSPACE_ROOT_DIR}:/fairspace"

    volumes="${volumes} -v /media:/media \
                        -v /tmp/.X11-unix:/tmp/.X11-unix \
                        -v /etc/localtime:/etc/localtime:ro \
                        -v /usr/src:/usr/src \
                        -v /lib/modules:/lib/modules"
    volumes="$(tr -s " " <<< "${volumes}")"
    eval "${retval}='${volumes}'"    
}

function post_run_setup() 
{
    if [ "${USER}" != "root" ]; 
    then
        docker exec -u root "${FAIRSPACE_DEV}" bash -c '/fairspace/scripts/docker_start_user.sh'
    fi
}

function main()
{
    check_host_environment

    parse_arguments "$@"

    info "Check and remove existing FAIRSPACE dev container ..."
    remove_existing_fairspace_dev_container

    local local_volumes=""
    mount_local_volumes local_volumes 

    info "Startarting docker container \"${ROS_DEV_CNTN}\" ..."

    local local_host="$(hostname)"
    local display="${DISPLAY:-:0}"    
    local host_name="dev-in-fairspace"
    local user="${USER}"
    local uid="$(id -u)"
    local group="$(id -g -n)"
    local gid="$(id -g)"
    # local host_ws_to_docker_ws="-v  ${WS_ROOT}:/home/hhkb/catkin_ws:rw"

    set -x

    XAUTH=/tmp/.docker.xauth
    if [ ! -f $XAUTH ]
    then
        xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
        if [ ! -z "$xauth_list" ]
        then
            echo $xauth_list | xauth -f $XAUTH nmerge -
        else
            sudo touch $XAUTH
        fi
        sudo chmod a+r $XAUTH
    fi

    xhost +SI:localuser:root

    docker run -itd \
        --privileged \
        --gpus all \
        --name "${FAIRSPACE_DEV}" \
        -e DISPLAY="${display}" \
        --env="XAUTHORITY=$XAUTH" \
        --volume="$XAUTH:$XAUTH" \
        -e DOCKER_USER="${user}" \
        -e USER="${user}" \
        -e DOCKER_USER_ID="${uid}" \
        -e DOCKER_GRP="${group}" \
        -e DOCKER_GRP_ID="${gid}" \
        -e DOCKER_IMG="${FAIRSPACE_DEV_IMAGE}" \
        ${local_volumes} \
        --network host \
        --add-host "${DEV_INSIDE}:127.0.0.1" \
        --add-host "${local_host}:127.0.0.1" \
        --hostname "${DEV_INSIDE}" \
        --shm-size 1g \
        -w /fairspace \
        -v /dev/null:/dev/raw1394 \
        "${FAIRSPACE_DEV_IMAG}" \
        /bin/bash

    if [[ $? -ne 0 ]]
    then
        error "Failed to start docker container \"${ROS_DEV_CNTN}\" based on \"${ROS_DEV_IMAG}\" "
        exit 1
    fi

    set +x
    post_run_setup

    ok "You have succesfully started \"${ROS_DEV_CNTN}\"."
}

main