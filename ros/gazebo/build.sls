# This file builds local ROS images using an ARM version of Ubuntu for use on
# the Raspberry Pi.

{% set version = salt['pillar.get']('rpi-cluster/gazebo:version', '7') %}
{% set ubuntu_image = salt['pillar.get']('ros:ubuntu_image', 'osrf/ubuntu_armhf:xenial') %}

{% set tmpdir = '/tmp/ros' %}

# Make sure we have the latest version of the Ubuntu ARM image.
{{ ubuntu_image }}:
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
    - require:
      - file: {{ tmpdir }}

# Modify the files for ARM.
{{ tmpdir }}/gazebo/gazebo{{ version }}/gzserver{{ version }}/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM armhf/ubuntu:xenial
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/gazebo/gazebo{{ version }}/libgazebo{{ version }}/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/gazebo:gzserver{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/gazebo/gazebo{{ version }}/gzclient{{ version }}/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/gazebo:gzserver{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git

{{ tmpdir }}/gazebo/gazebo{{ version }}/gzweb{{ version }}/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/gazebo:libgazebo{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git

# Build our images using `docker build`.
rpi-cluster/gazebo:gzserver{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}/gazebo/gazebo{{ version }}/gzserver{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: {{ tmpdir }}/gazebo/gazebo{{ version }}/gzserver{{ version }}/Dockerfile

rpi-cluster/gazebo:libgazebo{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}/gazebo/gazebo{{ version }}/libgazebo{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git
      - dockerng: rpi-cluster/gazebo:gzserver{{ version }}
      - file: {{ tmpdir }}/gazebo/gazebo{{ version }}/libgazebo{{ version }}/Dockerfile

rpi-cluster/gazebo:gzclient{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}/gazebo/gazebo{{ version }}/gzclient{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git
      - dockerng: rpi-cluster/gazebo:gzserver{{ version }}
      - file: {{ tmpdir }}/gazebo/gazebo{{ version }}/gzclient{{ version }}/Dockerfile

rpi-cluster/gazebo:gzweb{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}/gazebo/gazebo{{ version }}/gzweb{{ version }}
    - require:
      - git: https://github.com/osrf/docker_images.git
      - dockerng: rpi-cluster/gazebo:libgazebo{{ version }}
      - file: {{ tmpdir }}/gazebo/gazebo{{ version }}/gzweb{{ version }}/Dockerfile
