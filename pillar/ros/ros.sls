ros:
  # Set the ROS distro.
  distro: kinetic
  # This is the install ation directory for the `docker-compose.yml` file and for certain other required files (if needed).
  installation_dir: /opt/ros
  # Change the ubuntu base image to be used with the distro. This should match
  # the distro's recommended release.
  ubuntu_image: osrf/ubuntu_armhf:xenial
