FROM resin/rpi-raspbian

ENV ROS_DISTRO {{ ros_distro }}

RUN echo "deb http://packages.ros.org/ros/ubuntu jessie main" > /etc/apt/sources.list.d/ros-latest.list \
  && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
  && apt-get -qq update && apt-get install --no-install-recommends -qqy \
    build-essential \
    cmake \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
  && rm -rf /var/lib/apt/lists/* \
  && rosdep init \
  && rosdep update \
  && mkdir -p ~/ros_catkin_ws

WORKDIR ~/ros_catkin_ws
VOLUME ~/ros_catkin_ws

RUN rosinstall_generator ros_comm --rosdistro $ROS_DISTRO --deps --wet-only --tar > $ROS_DISTRO-ros_comm-wet.rosinstall \
  && wstool init src $ROS_DISTRO-ros_comm-wet.rosinstall \
  && ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/$ROS_DISTRO \
  && echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
