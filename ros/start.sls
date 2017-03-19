# This file is a Salt orchestration script for starting up a ROS environment on
# a Raspberry Pi cluster. See https://github.com/ajthor/rpi-cluster for more
# information.

# Include the build process for the images.
include:
  - ros.images.build

# Create a network specifically for ROS communications.
# `$ docker network create ROS --driver overlay`
ros-network:
  dockerng.network_present:
    - name: ROS
    - driver: overlay

# Start roscore as a regular command.
# $ docker run -it --rm \
#     --net foo \
#     --name master \
#     ros:ros-tutorials \
#     roscore

# start-roscore:
#   dockerng.running:
#     - name: ros-master
#     - image: armhf-indigo-ros-base
#     - interactive: True
#     - tty: True
#     - network_mode: ROS
#     - cmd: roscore

# $ docker run -it --rm --net ros --name ros-master ros:armhf-indigo-ros-base roscore
# $ docker service create -t --name roscore --network ROS ros:armhf-indigo-ros-base roscore

# Can specify constraints when starting particular services using
#
# --constraint 'node.hostname == rpi-master'
# --constraint 'node.hostname != rpi-master'
