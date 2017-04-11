FROM rpi-cluster/python

ENV LANG=C.UTF-8 \
    ROS_DISTRO=kinetic \
    BOOST_ROOT="/usr/lib" \
    BOOST_INCLUDE="/usr/include"

# Install dependencies.
RUN apk add --no-cache \
    ca-certificates \
  && apk add --no-cache --virtual .build-deps \
    boost-dev \
    bzip2-dev \
    gnupg \
    cmake \
    g++ \
    gcc \
    git \
    libc-dev \
    libedit-dev \
    libgcc \
    libstdc++ \
    linux-headers \
    lz4-dev \
    ncurses-dev \
    openssl-dev \
    sqlite-dev \
    pax-utils \
    py2-pip \
    python2-dev \
    make \
		musl-dev \
    tinyxml-dev \
    zlib-dev \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116 \
  && pip install -U \
    rosdep \
    rosinstall \
    rosinstall_generator \
    wstool \
    empy \
  && rosdep init \
  && mkdir ~/ros_catkin_ws \
  && mkdir ~/deps && mkdir ~/deps/console_bridge && cd ~/deps/console_bridge \
  && git clone git://github.com/ros/console_bridge.git \
  && cd console_bridge \
  && cmake . \
  && make \
  && make install

WORKDIR ~/ros_catkin_ws
VOLUME ~/ros_catkin_ws

RUN rosinstall_generator ros_comm --rosdistro $ROS_DISTRO --deps --wet-only --tar > $ROS_DISTRO-ros_comm-wet.rosinstall \
  && wstool init -j8 src $ROS_DISTRO-ros_comm-wet.rosinstall \
  && ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=MinSizeRel --install-space /opt/ros/kinetic -j2


RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# rosinstall_generator ros_comm --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall \
# wstool init -j8 src kinetic-ros_comm-wet.rosinstall \
# && ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
