#!/usr/bin/env bash

set -e

echo "Installing DynamixelSDK ..."

cd "$(dirname "${BASH_SOURCE[0]}")"
source ./installer_base.sh

pkg="DynamixelSDK"
version="3.7.31"

pkg_base_name="${pkg}-${version}"
pkg_tar="${pkg_base_name}.tar.gz"
pkg_tar_fullname="${FAIRSPACE_BUILD_ARCHIVE_DIR}/${pkg_base_name}.tar.gz"

echo "heheh"
echo ${FAIRSPACE_BUILD_ARCHIVE_DIR}
cd $FAIRSPACE_BUILD_ARCHIVE_DIR
echo $pkg_tar_fullname
if [[ -f ${pkg_tar_fullname} ]]
then
    info "Found a ${pkg} source: ${pkg_targ}"

    pushd ${FAIRSPACE_BUILD_ARCHIVE_DIR}
    tar -zxf ${pkg_tar} --directory ${FAIRSPACE_PKGS_DIR}
        pushd ${FAIRSPACE_PKGS_DIR}/${pkg_base_name}
        cd c++
        cd build/linux64
        make
        make install

        cd ../../example/dxl_monitor/linux64
        make

        popd
    popd

else
    info "--> Not found a ${pkg} source"
fi

echo "DynamixelSDK installation done."