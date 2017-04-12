# This file will configure the Docker service and manage other configuration
# settings on the targets.

{% set installation_dir = salt['pillar.get']('ros:installation_dir') %}

# Install ros.
build-ros-images:
  salt.state:
    - sls: ros.ros.build
    - tgt: 'rpi-master'

# Copy the docker-compose file to the node.
{{ installation_dir }}/docker-compose.yml:
  file.managed:
    - source: salt://ros/docker-compose.yml
    - makedirs: True
