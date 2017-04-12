# This file is the Salt function for starting up a ROS environment on a
# Raspberry Pi cluster.

docker-compose:
  pip.installed

start-ros:
  cmd.run:
    - name: docker-compose up -d
    - cwd: /opt/ros
    - require:
      - pip: docker-compose
