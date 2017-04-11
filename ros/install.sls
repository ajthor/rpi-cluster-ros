# Install ros.
build-ros-images:
  salt.state:
    - sls: ros.ros.build
    - tgt: 'rpi-master'
