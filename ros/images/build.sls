# Make sure we have the latest version of the Ubuntu ARM image.
osrf/ubuntu_armhf:trusty:
  dockerng.image_present

# Copy over the dockerfiles to the build directories.
/home/pi/docker/armhf-indigo-ros-core/Dockerfile:
  file.managed:
    - source: salt://ros/images/armhf-indigo-ros-core/Dockerfile
    - makedirs: True

/home/pi/docker/armhf-indigo-ros-core/ros_entrypoint.sh:
  file.managed:
    - source: salt://ros/images/armhf-indigo-ros-core/ros_entrypoint.sh
    - makedirs: True

/home/pi/docker/armhf-indigo-ros-base/Dockerfile:
  file.managed:
    - source: salt://ros/images/armhf-indigo-ros-base/Dockerfile
    - makedirs: True

# Build our images using `docker build`.
ros/armhf-indigo-ros-core:trusty:
  dockerng.image_present:
    - build: /home/pi/docker/armhf-indigo-ros-core
    - require:
      - file: /home/pi/docker/armhf-indigo-ros-core/Dockerfile
    # - dockerfile: salt://ros/images/armhf-indigo-ros-core/Dockerfile

ros/armhf-indigo-ros-base:trusty:
  dockerng.image_present:
    - build: /home/pi/docker/armhf-indigo-ros-base
    - require:
      - file: /home/pi/docker/armhf-indigo-ros-base/Dockerfile
      - dockerng: ros/armhf-indigo-ros-core:trusty
    # - dockerfile: salt://ros/images/armhf-indigo-ros-base/Dockerfile
