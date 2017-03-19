FROM ros:armhf-indigo-ros-core:trusty

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-base=1.1.4-0* \
    && rm -rf /var/lib/apt/lists/*
