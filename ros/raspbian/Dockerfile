FROM resin/rpi-raspbian

ENV ROS_DISTRO={{ ros_distro }}

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu jessie main" > /etc/apt/sources.list.d/ros-latest.list' \
  && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
  && apt-get update -q && apt-get upgrade -qqy \
  && apt-get install --no-install-recommends -qy \
    build-essential \
    cmake \
    python-rosdep \
    python-rosinstall-generator \
    python-wstool \
    python-rosinstall \
  && rosdep init \
  && rosdep update \
  && mkdir ~/ros_catkin_ws \
  && mkdir ~/deps && cd ~/deps \
  && git clone git://github.com/ros/console_bridge.git \
  && cd ~/deps/console_bridge \
  && cmake . \
  && make \
  && make install \
  && cd ~/ros_catkin_ws

WORKDIR ~/ros_catkin_ws
VOLUME ~/ros_catkin_ws

RUN rosinstall_generator ros_comm --rosdistro $ROS_DISTRO --deps --wet-only --tar > $ROS_DISTRO-ros_comm-wet.rosinstall \
  && wstool init src $ROS_DISTRO-ros_comm-wet.rosinstall \
  && rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y \
  && ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=MinSizeRel --install-space /opt/ros/$ROS_DISTRO -j2 \
  && echo "source ~/ros_catkin_ws/install_isolated/setup.bash" >> ~/.bashrc
