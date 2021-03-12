FROM osrf/ros:foxy-desktop

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


# ARG uid=1000
# ARG gid=1000
# RUN groupadd -r -f -g ${gid} fairspace \
#     && useradd -r -u ${uid} -o -g ${gid} -s /bin/bash -m hhkb
# RUN usermod -aG sudo hhkb 
    # && usermod -aG fairspace  

# COPY docker/installers/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

# ENV DEBIAN_FRONTEND=noninteractive

# COPY docker/installers /opt/fairspace/build/installers
# COPY docker/archive /opt/fairspace/build/archive

# Preset fairspace
# ENV FAIRSPACE_SYSTEMROOT_DIR /opt/fairspace/sysroot
# ENV FAIRSPACE_LD_FILE "/etc/ld.so.conf.d/fairspace.conf"
# RUN bash /opt/fairspace/build/installers/preset_fairspace.sh
# RUN bash /home/hhkb/build/installers/init_apt.sh

# Login hhkb and install packages
# USER hhkb:fairspace
# ENV PATH /opt/fairspace/sysroot/bin${PATH:+:${PATH}}
# RUN bash /opt/fairspace/build/installers/preset_hhkb_catkin.sh
# ENV HHKB_BUILD_ARCHIVE_DIR /home/fairspace/build/archive

# RUN bash /home/hhkb/build/installers/install_cmake.sh
# RUN bash /opt/fairspace/build/installers/install_bullet3.sh

# Postset fairspace
# RUN bash /opt/fairspace/build/installers/postset_fairspace.sh

# WORKDIR /home/hhkb/catkin_ws
WORKDIR /ros2_ws

# RUN ["/bin/bash"]

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

