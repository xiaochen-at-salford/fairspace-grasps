#!/usr/bin/env bash

set -e

echo "Current user: $(whoami)"
echo "Append ROS setup.bash to .bashrc"

cd /home/hhkb

cat <<-EOF >> "/home/hhkb/.bashrc"

if [[ -f .catkin_workspace ]]
then
    echo "Detect a catkin workspace at $(pwd)"
    source devel/setup.bash
else
    echo "Not found a catkin workspace yet, check /home/hhkb/catkin_ws?"
fi
EOF

