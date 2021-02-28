#!/usr/bin/env bash

set -e

echo "Current user: $(whoami)"
echo "Iniatiate Synergy HHKB environment"
echo "CPU ARCH: $(uname -m)"

cd "$(dirname "${BASH_SOURCE[0]}")"
source ./installer_base.sh

mkdir -p /opt/fairspace/sysroot
mkdir -p /opt/fairspace/sysroot/{bin,include,lib,share}
mkdir -p /opt/fairspace/pkgs

# Workspace for thirdparty ROS2 packages
mkdir -p /ros2_fs/src

# FAIRSPACE ROS2 workspace
mkdir /fairspace

# chown -R hhkb:fairspace /home/hhkb
# chown -R hhkb:fairspace /opt/ros
# chown -R hhkb:fairspace /opt/hhkb

# Enable no-password sudo  
apt_get_update_and_install sudo sed
sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

if [[ ! -f ${FAIRSPACE_LD_FILE} ]]
then
    echo "${FAIRSPACE_SYSTEMROOT_DIR}/lib" | tee -a ${FAIRSPACE_LD_FILE}
fi

ldconfig

apt-get clean && rm -rf /var/lib/apt/lists/
