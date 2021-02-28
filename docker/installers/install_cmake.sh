#!/usr/bin/env bash

set -e

echo "Current user: $(whoami)"
echo "Install cmake ..."

cd "$(dirname "${BASH_SOURCE[0]}")"
source ./installer_base.sh

cmake_version="3.18.5"
cmake_base_name="cmake-${cmake_version}"
cmake_tar="${cmake_base_name}.tar.gz"
cmake_tar_fullname="${HHKB_BUILD_ARCHIVE_DIR}/${cmake_base_name}.tar.gz"

if [[ -f ${cmake_tar_fullname} ]]
then
    echo "--> Found a cmake source: ${cmake_tar}"
    
    # Just remove cmake
    sudo dpkg -r --force-depends cmake

    # sudo apt update
    # sudo apt --fix-broken install
    # sudo apt install -y libssl-dev libcurl4-openssl-dev

    pushd ${HHKB_BUILD_ARCHIVE_DIR}
    tar -zxf ${cmake_tar}
        pushd ${cmake_base_name}
        ./bootstrap
        make -j$(nproc)
        sudo make install
        popd
    popd
    sudo ldconfig 
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
else
    echo "--> Not found a cmake source"
fi