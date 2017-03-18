# Make sure we have the latest version of the Ubuntu ARM image.
osrf/ubuntu_armhf:
  dockerng.image_present

/home/pi/docker/armhf-indigo-ros-core/Dockerfile:
  file.managed:
    - source: salt://ros/images/armhf-indigo-ros-core/Dockerfile
    - makedirs: True

/home/pi/docker/armhf-indigo-ros-base/Dockerfile:
  file.managed:
    - source: salt://ros/images/armhf-indigo-ros-base/Dockerfile
    - makedirs: True

# Build our images using `docker build`.
ros/armhf-indigo-ros-core:trusty:
  dockerng.image_present:
    - build: /home/pi/docker/armhf-indigo-ros-core
    # - dockerfile: salt://ros/images/armhf-indigo-ros-core/Dockerfile

ros/armhf-indigo-ros-base:trusty:
  dockerng.image_present:
    - build: /home/pi/docker/armhf-indigo-ros-base
    # - dockerfile: salt://ros/images/armhf-indigo-ros-base/Dockerfile
