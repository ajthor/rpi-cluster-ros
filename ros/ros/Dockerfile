FROM resin/rpi-raspbian

# Set environment variables.
ENV ROS_DISTRO={{ distro }} \
    ROS_UBUNTU_REPO={{ ubuntu_repo }}

ENV LANG=C.UTF-8

# Install ROS.
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $ROS_UBUNTU_REPO main" > /etc/apt/sources.list.d/ros-latest.list' \
  && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
  && apt-get update -q && apt-get upgrade -qqy \
  && apt-get install --no-install-recommends -qy \
    python-rosdep \
    python-rosinstall \
  && rosdep init \
  && rosdep update \
  && apt-get update -q && apt-get install --no-install-recommends -qy \
    ros-$ROS_DISTRO-ros-base \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory to the catkin workspace.
WORKDIR ~/catkin_ws

# Set the entrypoint.
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
