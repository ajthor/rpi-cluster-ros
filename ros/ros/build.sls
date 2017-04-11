# This file builds local ROS images using an ARM version of Ubuntu Trusty for
# use on the Raspberry Pi.

{% set ros_distro = salt['pillar.get']('drone:ros_distro', 'kinetic') %}
{% set ubuntu_image = salt['pillar.get']('drone:ubuntu_image', 'osrf/ubuntu_armhf:xenial') %}

{% set tmpdir = '/tmp/ros' %}

# Make sure we have the latest version of the Ubuntu ARM image.
osrf/ubuntu_armhf:xenial:
  dockerng.image_present

# Ensure the directory exists.
{{ tmpdir }}:
  file.directory:
    - makedirs: True

# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/osrf/docker_images.git:
  git.latest:
    - target: {{ tmpdir }}
    - branch: master

# Modify the files for ARM.
{{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-ros-core/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM {{ ubuntu_image }}
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-ros-base/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/ros:{{ ros_distro }}-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-robot/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/ros:{{ ros_distro }}-ros-base
    - require:
      - git: https://github.com/osrf/docker_images.git

# Build our images using `docker build`.
rpi-cluster/ros:{{ ros_distro }}-ros-core:
  dockerng.image_present:
    - build: {{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-ros-core/Dockerfile

rpi-cluster/ros:{{ ros_distro }}-ros-base:
  dockerng.image_present:
    - build: {{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-ros-base
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-ros-base/Dockerfile
      - dockerng: ros:{{ ros_distro }}-ros-core-armhf

rpi-cluster/ros:{{ ros_distro }}-robot:
  dockerng.image_present:
    - build: {{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-robot
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/ros/{{ ros_distro }}/{{ ros_distro }}-robot/Dockerfile
      - dockerng: ros:{{ ros_distro }}-ros-base-armhf
