#!/usr/bin/env bash

set -e

echo "Installing Movetlt2 ... "


apt-get -qq update 
# apt-get dist-upgrade

# Install some base dependencies
# apt-get install --no-install-recommends -y \
    # Some basic requirements
    # wget git sudo curl \
    # Preferred build tools
    # clang clang-format-10 clang-tidy clang-tools \
    # ccache


source /opt/ros/foxy/setup.bash 

COLCON_WS=/ros2_fs
mkdir -p $COLCON_WS/src
# cd $COLCON_WS
# colcon build
# source $COLCON_WS/install/setup.bash

cd $COLCON_WS/src
wget https://raw.githubusercontent.com/ros-planning/moveit2/main/moveit2.repos
vcs import < moveit2.repos
rosdep install -r --from-paths . --ignore-src --rosdistro foxy -y --as-root=apt:false

cd $COLCON_WS
colcon build --event-handlers desktop_notification- status- --cmake-args -DCMAKE_BUILD_TYPE=Release

echo "MoveIt2 installation done."