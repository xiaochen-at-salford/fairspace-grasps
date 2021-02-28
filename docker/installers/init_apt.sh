#!/usr/bin/env bash

set -e

echo "Current user: $(whoami)"
echo "Iniatiate FairSpace HHKB environment"
echo "CPU ARCH: $(uname -m)"

cd "$(dirname "${BASH_SOURCE[0]}")"
source ./installer_base.sh

sudo_apt_update_and_install \
    apt-utils \
    iputils-ping \
    cmake-gui \
    libnvidia-gl-450

sudo_apt_update_and_install \
    wget 

sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/