# This file builds local ROS images using an ARM version of Ubuntu Trusty for
# use on the Raspberry Pi.

# Make sure we have the latest version of the Ubuntu ARM image.
osrf/ubuntu_armhf:trusty:
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
/home/pi/docker/osrf/ros/indigo/indigo-ros-core/Dockerfile:
  file.replace:
    - pattern: FROM ubuntu:trusty
    - repl: FROM osrf/ubuntu_armhf:trusty
    - require:
      - git: https://github.com/osrf/docker_images.git

/home/pi/docker/osrf/ros/indigo/indigo-ros-base/Dockerfile:
  file.replace:
    - pattern: FROM ros:indigo-ros-core
    - repl: FROM ros:armhf-indigo-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git

#
#     https://github.com/osrf/docker_images.git

# Copy over the dockerfiles to the build directories.
# /home/pi/docker/ros/armhf-indigo-ros-core/Dockerfile:
#   file.managed:
#     - source: salt://ros/images/armhf-indigo-ros-core/Dockerfile
#     - makedirs: True
#
# /home/pi/docker/ros/armhf-indigo-ros-core/ros_entrypoint.sh:
#   file.managed:
#     - source: salt://ros/images/armhf-indigo-ros-core/ros_entrypoint.sh
#     - makedirs: True
#     - mode: 755
#
# /home/pi/docker/ros/armhf-indigo-ros-base/Dockerfile:
#   file.managed:
#     - source: salt://ros/images/armhf-indigo-ros-base/Dockerfile
#     - makedirs: True

# Build our images using `docker build`.
ros:armhf-indigo-ros-core:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/ros/indigo/indigo-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: /home/pi/docker/osrf/ros/indigo/indigo-ros-core/Dockerfile

ros:armhf-indigo-ros-base:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/ros/indigo/indigo-ros-base
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: /home/pi/docker/osrf/ros/indigo/indigo-ros-base/Dockerfile
      - dockerng: ros:armhf-indigo-ros-core
