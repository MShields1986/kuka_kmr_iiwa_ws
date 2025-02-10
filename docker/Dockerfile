FROM ros:noetic-ros-base

ARG GIT_USER_NAME
ARG GIT_ACCESS_TOKEN

ENV GIT_USER_NAME ${GIT_USER_NAME?git_user_not_set}
ENV GIT_ACCESS_TOKEN ${GIT_ACCESS_TOKEN?git_token_not_set}

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && sudo apt-get install -y git python3-catkin-tools
# libzmq3-dev libboost-dev ros-noetic-behaviortree-cpp-v3

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
 && catkin build \
 && echo 'source /opt/ros/noetic/setup.bash' >> /root/.bashrc \
 && echo 'source /catkin_ws/devel/setup.bash' >> /root/.bashrc \
 && echo 'source /catkin_ws/devel/setup.bash' >> /ros_entrypoint.sh

RUN sed -i '/exec "$@"/d' /ros_entrypoint.sh \
 && echo 'exec "$@"' >> /ros_entrypoint.sh

ENTRYPOINT [ "/ros_entrypoint.sh" ]

ENV DEBIAN_FRONTEND=dialog
