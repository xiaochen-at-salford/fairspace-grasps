#!/usr/bin/env bash

set -e

echo "Current user: $(whoami)"
echo "Install bullet3 ..."

cd "$(dirname "${BASH_SOURCE[0]}")"
source ./installer_base.sh

pkg="bullet3"
version="3.07"
# version="3.97.2"
# version="0.0"
pkg_base_name="${pkg}-${version}"
pkg_tar="${pkg_base_name}.tar.gz"
pkg_tar_fullname="${HHKB_BUILD_ARCHIVE_DIR}/${pkg_base_name}.tar.gz"

if [[ -f ${pkg_tar_fullname} ]]
then
    info "Found a ${pkg} source: ${pkg_targ}"

    pushd ${HHKB_BUILD_ARCHIVE_DIR}
    tar -zxf ${pkg_tar}
        pushd ${pkg_base_name}
        if [[ -e CMakeCache.txt ]] 
        then
            rm CMakeCache.txt
        fi
            mkdir -p build && cd build
            cmake -DUSE_DOUBLE_PRECISION=ON \
                  -DBUILD_EGL=ON \
                  -DCMAKE_BUILD_TYPE=Debug \
                  -DBUILD_SHARED_LIBS=ON \
                  -DCMAKE_INSTALL_PREFIX=/opt/hhkb/sysroot \
                  ..
            
            make -j$(nproc)
            make install

            sudo ldconfig

            # cmake3-10 cannot find the default "BulletConfig.cmake" 
            mv /opt/hhkb/sysroot/lib/cmake/bullet/BulletConfig.cmake \
               /opt/hhkb/sysroot/lib/cmake/bullet/bullet-config.cmake
        popd
    popd

    # echo "export PKG_CONFIG_PATH=/opt/hhkb/pkgconfig\${PKG_CONFIG_PATH:+:\${PKG_CONFIG_PATH}}" >> ~/.bashrc
else
    info "--> Not found a ${pkg} source"
fi
