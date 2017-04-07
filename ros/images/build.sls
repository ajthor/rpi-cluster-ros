# This file builds local ROS images using an ARM version of Ubuntu Trusty for
# use on the Raspberry Pi.

# Make sure we have the latest version of the Ubuntu ARM image.
osrf/ubuntu_armhf:xenial:
  dockerng.image_present

# Ensure the directory exists.
/home/pi/docker/osrf:
  file.directory:
    - makedirs: True

# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/osrf/docker_images.git:
  git.latest:
    - target: /home/pi/docker/osrf
    - branch: master

# Modify the files for ARM.
/home/pi/docker/osrf/ros/kinetic/kinetic-ros-core/Dockerfile:
  file.replace:
    - pattern: FROM ubuntu:xenial
    - repl: FROM osrf/ubuntu_armhf:xenial
    - require:
      - git: https://github.com/osrf/docker_images.git

/home/pi/docker/osrf/ros/kinetic/kinetic-ros-base/Dockerfile:
  file.replace:
    - pattern: FROM ros:kinetic-ros-core
    - repl: FROM ros:kinetic-ros-core-armhf
    - require:
      - git: https://github.com/osrf/docker_images.git

/home/pi/docker/osrf/ros/kinetic/kinetic-robot/Dockerfile:
  file.replace:
    - pattern: FROM ros:kinetic-ros-base
    - repl: FROM ros:kinetic-ros-base-armhf
    - require:
      - git: https://github.com/osrf/docker_images.git

# Build our images using `docker build`.
ros:kinetic-ros-core-armhf:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/ros/kinetic/kinetic-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: /home/pi/docker/osrf/ros/kinetic/kinetic-ros-core/Dockerfile

ros:kinetic-ros-base-armhf:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/ros/kinetic/kinetic-ros-base
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: /home/pi/docker/osrf/ros/kinetic/kinetic-ros-base/Dockerfile
      - dockerng: ros:kinetic-ros-core-armhf

ros:kinetic-robot-armhf:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/ros/kinetic/kinetic-robot
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: /home/pi/docker/osrf/ros/kinetic/kinetic-robot/Dockerfile
      - dockerng: ros:kinetic-ros-base-armhf
