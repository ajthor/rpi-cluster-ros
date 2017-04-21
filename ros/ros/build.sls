# This file builds local ROS images using an ARM version of Ubuntu for use on
# the Raspberry Pi.

{% set distro = salt['pillar.get']('ros:distro') %}
{% set ubuntu_repo = salt['pillar.get']('ros:ubuntu_repo') %}

{% set tempdir = salt['cmd.run']('mktemp -d -t ros.XXXXXX') %}

resin/rpi-raspbian:
  dockerng.image_present

# Add the Dockerfile from repo.
{{ tempdir }}/Dockerfile:
  file.managed:
    - source: salt://ros/ros/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      distro: {{ distro }}
      ubuntu_repo: {{ ubuntu_repo }}

{{ tempdir }}/ros_entrypoint.sh:
  file.managed:
    - source: salt://ros/ros/ros_entrypoint.sh
    - makedirs: True

# Build the image.
rpi-cluster/ros:{{ distro }}-ros-base:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - file: {{ tempdir }}/Dockerfile
      - file: {{ tempdir }}/ros_entrypoint.sh
