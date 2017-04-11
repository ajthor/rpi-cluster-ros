# This file is meant to be run using Salt orchestrate, using a command such as:
# `sudo salt-run state.orchestrate ros.bootstrap`

# Configure pillar.
configure-pillar:
  salt.state:
    - sls: ros.pillar
    - tgt: 'rpi-master'

# Install ros.
install-ros:
  salt.state:
    - sls: ros.install
    - tgt: 'rpi-master'
