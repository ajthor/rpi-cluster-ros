FROM osrf/ubuntu_armhf:xenial

# Install necessary build tools.
RUN apt-get update && apt-get install -qy \
    g++ \
    gcc \
    cmake \
    lsb-release \
    mercurial \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Get the latest source.
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

# Get the package key.
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

# Update apt.
RUN apt-get update

# Get the dependencies.
RUN wget https://bitbucket.org/osrf/release-tools/raw/default/jenkins-scripts/lib/dependencies_archive.sh -O /tmp/dependencies.sh

# Set the ros distro to the latest version.
ENV ROS_DISTRO kinetic
# . /tmp/dependencies.sh

# Install dependencies.
RUN ["/bin/bash", "-c", "apt-get install -y $(sed 's:\\ ::g' <<< $BASE_DEPENDENCIES) $(sed 's:\\ ::g' <<< $GAZEBO_BASE_DEPENDENCIES)"]

# Clone the repo.
RUN hg clone https://bitbucket.org/osrf/gazebo -r gazebo8 /tmp/gazebo

# Create build directories.
RUN mkdir /tmp/gazebo/build

# Run cmake.
RUN cmake -B/tmp/gazebo/build -H/tmp/gazebo

# Build gazebo.
RUN make -j4

# Install gazebo.
RUN make install

# Set up environment.
EXPOSE 11345

# Set up entrypoint.
COPY ./gzserver_entrypoint.sh /

ENTRYPOINT ["/gzserver_entrypoint.sh"]
CMD ["gzserver"]
