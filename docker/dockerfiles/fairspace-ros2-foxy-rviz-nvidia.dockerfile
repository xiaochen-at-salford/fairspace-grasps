FROM osrf/ros:foxy-desktop

#nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /tmp/installers

COPY docker/installers /tmp/installers
COPY docker/build/rcfiles /opt/fairspace/rcfiles

# Host environment variables
ENV HOST_BUILD_ARCHIVE_DIR docker/archive

# FAIRSPACE environment variables
ENV FAIRSPACE_SYSTEMROOT_DIR /opt/fairspace/sysroot
ENV FAIRSPACE_PKGS_DIR /opt/fairspace/pkgs
ENV FAIRSPACE_LD_FILE "/etc/ld.so.conf.d/fairspace.conf"
ENV FAIRSPACE_BUILD_ARCHIVE_DIR /tmp/fairspace/pkgs

RUN bash /tmp/installers/preset_fairspace.sh

RUN bash /tmp/installers/init_apt.sh
RUN bash /tmp/installers/install_moveit2.sh

COPY ${HOST_BUILD_ARCHIVE_DIR}/DynamixelSDK-3.7.31.tar.gz ${FAIRSPACE_BUILD_ARCHIVE_DIR}/
RUN bash /tmp/installers/install_dynamixelsdk.sh


# RUN bash /tmp/installers/install_minimal_environment.sh ${GEOLOC}

# RUN bash /tmp/installers/install_cmake.sh
# RUN bash /tmp/installers/install_cyber_deps.sh ${INSTALL_MODE}
# RUN bash /tmp/installers/install_llvm_clang.sh
# RUN bash /tmp/installers/install_qa_tools.sh
# RUN bash /tmp/installers/install_visualizer_deps.sh
# RUN bash /tmp/installers/install_bazel.sh
# RUN bash /tmp/installers/post_install.sh cyber

WORKDIR /fairspace