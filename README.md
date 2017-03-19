# Raspberry Pi Cluster ROS Package

This repo contains Salt scripts and information on how to get ROS/Gazebo running using Docker Swarm on a Raspberry Pi Cluster.

Take a look at [rpi-cluster](https://github.com/ajthor/rpi-cluster) for more information on the Raspberry Pi Cluster project and the [rpi-cluster wiki](https://github.com/ajthor/rpi-cluster/wiki) for more information on how to set up your own Raspberry Pi cluster.

This repo takes advantage of the [images](https://hub.docker.com/u/osrf/) provided by [OSRF, the Open Source Robotics Foundation](https://www.osrfoundation.org).

# Usage

1. Add the repo to the Salt `manager` file.

    ```
    gitfs_remotes:
      - https://github.com/ajthor/rpi-cluster-salt.git
      - https://github.com/ajthor/rpi-cluster-ros.git
    ```

2. Start `roscore` on the cluster by running the following command:

    ```Shell
    $ sudo salt-run state.orchestrate ros.start
    ```

## Salt Scripts

This repo contains Salt scripts for building ARM-compatible Docker images, and managing and interacting with ROS in the cluster. See the [wiki](https://github.com/ajthor/rpi-cluster-ros/wiki) for more information.

- [Build](https://github.com/ajthor/rpi-cluster-salt/wiki/Build)
- [Start](https://github.com/ajthor/rpi-cluster-salt/wiki/Start)

---

# Contribute

If you would like to contribute to this project, please fork and pull request. I'm happy to support any contributions to this project.
