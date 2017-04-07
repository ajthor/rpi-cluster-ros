

# Make sure we have the latest version of the Ubuntu ARM image.
armhf/ubuntu:xenial:
  dockerng.image_present

# Ensure the directory exists.
/home/pi/docker/osrf:
  file.directory:
    - makedirs: True

# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/osrf/docker_images.git:
  git.latest:
    - target: /home/pi/docker/osrf
    - branch: master
    - require:
      - file: /home/pi/docker/osrf

# Modify the files for ARM.
/home/pi/docker/osrf/gazebo/gazebo8/gzserver8/Dockerfile:
  file.replace:
    - pattern: FROM ubuntu:xenial
    - repl: FROM armhf/ubuntu:xenial
    - require:
      - git: https://github.com/osrf/docker_images.git

/home/pi/docker/osrf/gazebo/gazebo8/libgazebo8/Dockerfile:
  file.replace:
    - pattern: FROM gazebo:gzserver8
    - repl: FROM gazebo:armhf_gzserver8
    - require:
      - git: https://github.com/osrf/docker_images.git

/home/pi/docker/osrf/gazebo/gazebo8/gzclient8/Dockerfile:
  file.replace:
    - pattern: FROM gazebo:gzserver8
    - repl: FROM gazebo:armhf_gzserver8
    - require:
      - git: https://github.com/osrf/docker_images.git

/home/pi/docker/osrf/gazebo/gazebo8/gzweb8/Dockerfile:
  file.replace:
    - pattern: FROM gazebo:libgazebo8
    - repl: FROM gazebo:armhf_libgazebo8
    - require:
      - git: https://github.com/osrf/docker_images.git

# Build our images using `docker build`.
gazebo:armhf_gzserver8:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/gazebo/gazebo8/gzserver8
    - require:
      - git: https://github.com/osrf/docker_images.git
      - file: /home/pi/docker/osrf/gazebo/gazebo8/gzserver8/Dockerfile

gazebo:armhf_libgazebo8:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/gazebo/gazebo8/libgazebo8
    - require:
      - git: https://github.com/osrf/docker_images.git
      - dockerng: gazebo:armhf_gzserver8
      - file: /home/pi/docker/osrf/gazebo/gazebo8/libgazebo8/Dockerfile

gazebo:armhf_gzclient8:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/gazebo/gazebo8/gzclient8
    - require:
      - git: https://github.com/osrf/docker_images.git
      - dockerng: gazebo:armhf_gzserver8
      - file: /home/pi/docker/osrf/gazebo/gazebo8/gzclient8/Dockerfile

gazebo:armhf_gzweb8:
  dockerng.image_present:
    - build: /home/pi/docker/osrf/gazebo/gazebo8/gzweb8
    - require:
      - git: https://github.com/osrf/docker_images.git
      - dockerng: gazebo:armhf_libgazebo8
      - file: /home/pi/docker/osrf/gazebo/gazebo8/gzweb8/Dockerfile
