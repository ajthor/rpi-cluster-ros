# This file builds local ROS images using an ARM version of Ubuntu for use on
# the Raspberry Pi.

{% set distro = salt['pillar.get']('ros:distro', 'kinetic') %}
{% set ubuntu_image = salt['pillar.get']('ros:ubuntu_image', 'osrf/ubuntu_armhf:xenial') %}

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
{{ tmpdir }}/ros/{{ distro }}/{{ distro }}-ros-core/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM {{ ubuntu_image }}
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/ros/{{ distro }}/{{ distro }}-ros-base/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/ros:{{ distro }}-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/ros/{{ distro }}/{{ distro }}-robot/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/ros:{{ distro }}-ros-base
    - require:
      - git: https://github.com/osrf/docker_images.git

# Build our images using `docker build`.
rpi-cluster/ros:{{ distro }}-ros-core:
  dockerng.image_present:
    - build: {{ tmpdir }}/ros/{{ distro }}/{{ distro }}-ros-core
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/ros/{{ distro }}/{{ distro }}-ros-core/Dockerfile

rpi-cluster/ros:{{ distro }}-ros-base:
  dockerng.image_present:
    - build: {{ tmpdir }}/ros/{{ distro }}/{{ distro }}-ros-base
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/ros/{{ distro }}/{{ distro }}-ros-base/Dockerfile
      - dockerng: rpi-cluster/ros:{{ distro }}-ros-core

rpi-cluster/ros:{{ distro }}-robot:
  dockerng.image_present:
    - build: {{ tmpdir }}/ros/{{ distro }}/{{ distro }}-robot
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/ros/{{ distro }}/{{ distro }}-robot/Dockerfile
      - dockerng: rpi-cluster/ros:{{ distro }}-ros-base
