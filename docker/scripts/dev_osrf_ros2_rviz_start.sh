# ROS_DEV_IMAGE="osrf/ros:foxy-desktop"
ROS_DEV_IMAGE="osrf-ros2-foxy-rviz"
ROS_DEV_CONTAINER="osrf-ros2-foxy-rviz-container"

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
    sudo chmod a+rw $XAUTH
fi

docker run -itd --rm \
    --name ${ROS_DEV_CONTAINER} \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --runtime=nvidia \
    ${ROS_DEV_IMAGE} \
    bash

