FROM ros:noetic-ros-base

ARG GIT_USER_NAME
ARG GIT_ACCESS_TOKEN

ENV GIT_USER_NAME ${GIT_USER_NAME?git_user_not_set}
ENV GIT_ACCESS_TOKEN ${GIT_ACCESS_TOKEN?git_token_not_set}

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y \
        git \
        python3-pip \
        wget \
        ocl-icd-libopencl1 \
 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get install -y git-lfs \
 && python3 -m pip install pyassimp


# for Zivid Nvidia
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN wget --quiet \
    https://downloads.zivid.com/sdk/releases/2.13.1+18e79e79-1/u20/amd64/zivid_2.13.1+18e79e79-1_amd64.deb \
    https://downloads.zivid.com/sdk/releases/2.13.1+18e79e79-1/u20/amd64/zivid-tools_2.13.1+18e79e79-1_amd64.deb \
    https://downloads.zivid.com/sdk/releases/2.13.1+18e79e79-1/u20/amd64/zivid-genicam_2.13.1+18e79e79-1_amd64.deb

RUN apt-get update
RUN apt-get install ./*.deb --assume-yes && rm ./*.deb


# OpenVDB
RUN apt-get install --no-install-recommends -y \
    libblosc-dev \
    libboost-iostreams-dev \
    libboost-system-dev \
    libboost-system-dev \
    libeigen3-dev \
    libtbb-dev \
 && git clone --depth 1 https://github.com/nachovizzo/openvdb.git -b nacho/vdbfusion \
 && cd openvdb \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DUSE_ZLIB=OFF .. \
 && make -j4 all install

# VDBFusion
RUN git clone --depth 1 https://github.com/PRBonn/vdbfusion.git \
 && cd vdbfusion \
 && mkdir build \
 && cd build \
 && cmake .. \
 &&  make -j4 all install


# catkin_ws
RUN apt-get install -y \
    python3-catkin-tools \
    python3-osrf-pycommon \
    libzmq3-dev \
    libboost-dev \
    ros-noetic-behaviortree-cpp-v3 \
    ros-noetic-realsense2-camera \
    ros-noetic-realsense2-description\
    ros-noetic-joy

COPY ../src /catkin_ws/src

WORKDIR /catkin_ws

RUN source /opt/ros/noetic/setup.bash \
# && git clone https://${GIT_USER_NAME}:${GIT_ACCESS_TOKEN}@github.com/UoS-EEE-Automation/eddyfi_ectane_ros.git \
# && rosinstall src src/test.rosinstall \
 && cd src \
 && ./test_pull.sh \
 && cd .. \
 && rosdep install -i --from-path src --rosdistro noetic -y \
 && catkin config --skiplist kmriiwa_gazebo \
 && catkin build

# Modify the entry point
RUN echo 'source /opt/ros/noetic/setup.bash' >> /root/.bashrc \
 && echo 'source /catkin_ws/devel/setup.bash' >> /root/.bashrc \
 && echo 'source /catkin_ws/devel/setup.bash' >> /ros_entrypoint.sh

RUN sed -i '/exec "$@"/d' /ros_entrypoint.sh \
 && echo 'exec "$@"' >> /ros_entrypoint.sh

ENTRYPOINT [ "/ros_entrypoint.sh" ]

ENV DEBIAN_FRONTEND=dialog
