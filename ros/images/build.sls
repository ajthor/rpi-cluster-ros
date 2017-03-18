# Make sure we have the latest version of the Ubuntu ARM image.
osrf/ubuntu_armhf:
  dockerng.image_present

dockerfiles:
  file.managed:
    - name: /home/pi/docker/armhf-indigo-ros-core/Dockerfile
    - source: salt://ros/images/armhf-indigo-ros-core/Dockerfile
  file.managed:
    - name: /home/pi/docker/armhf-indigo-ros-base/Dockerfile
    - source: salt://ros/images/armhf-indigo-ros-base/Dockerfile

# Build our images using `docker build`.
ros/armhf-indigo-ros-core:trusty:
  dockerng.image_present:
    - build: /home/pi/docker/armhf-indigo-ros-core
    # - dockerfile: salt://ros/images/armhf-indigo-ros-core/Dockerfile

ros/armhf-indigo-ros-base:trusty:
  dockerng.image_present:
    - build: /home/pi/docker/armhf-indigo-ros-base
    # - dockerfile: salt://ros/images/armhf-indigo-ros-base/Dockerfile
