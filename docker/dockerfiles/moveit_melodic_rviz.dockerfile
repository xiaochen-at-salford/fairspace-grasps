FROM moveit/moveit:melodic-source

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y libgl1-mesa-glx \
                      libgl1-mesa-dri \
                      mesa-utils \
                      libcanberra-gtk-module \
                      libcanberra-gtk3-module \
                      dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

RUN apt update \
    && apt install -y tmux sudo sed \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

RUN mkdir /ros_ws \
    && mkdir /fairspace

CMD ["/bin/bash"]

