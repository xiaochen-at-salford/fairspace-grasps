FROM osrf/ros:melodic-desktop-bionic
# FROM osrf/ros:melodic-desktop-full-bionic

ARG uid=1000
ARG gid=1000
RUN groupadd -r -f -g ${gid} fairspace \
    && useradd -r -u ${uid} -o -g ${gid} -s /bin/bash -m hhkb
RUN usermod -aG sudo hhkb 
    # && usermod -aG fairspace  

# COPY docker/installers/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

ENV DEBIAN_FRONTEND=noninteractive

COPY docker/installers /home/hhkb/build/installers
COPY docker/archive /home/hhkb/build/archive

# Preset hhkb
ENV HHKB_SYSTEMROOT_DIR /opt/hhkb/sysroot
ENV HHKB_LD_FILE "/etc/ld.so.conf.d/hhkb.conf"
RUN bash /home/hhkb/build/installers/preset_hhkb.sh
RUN bash /home/hhkb/build/installers/init_apt.sh

# Login hhkb and install packages
USER hhkb:fairspace
ENV PATH /opt/hhkb/sysroot/bin${PATH:+:${PATH}}
RUN bash /home/hhkb/build/installers/preset_hhkb_catkin.sh
ENV HHKB_BUILD_ARCHIVE_DIR /home/hhkb/build/archive

# RUN bash /home/hhkb/build/installers/install_cmake.sh
RUN bash /home/hhkb/build/installers/install_bullet3.sh

# Postset hhkb
RUN bash /home/hhkb/build/installers/postset_hhkb.sh

WORKDIR /home/hhkb/catkin_ws

# RUN ["/bin/bash"]

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

