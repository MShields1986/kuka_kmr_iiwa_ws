## Install
I would recommend following [this guide](https://github.com/UoS-EEE-Automation/kmr_ros_install_guide/blob/main/ROS_SETUP.md) for basic ROS and network setup  and [this guide](https://github.com/UoS-EEE-Automation/kmr_ros_install_guide/blob/main/CHRONY_NTP_SETUP.md) for setting up the "on robot PC" as an NTP server and the "remote PC" as an NTP client.

Laptop needs to be on 172.31.1.137
Remote PC can be on any other valid IP, but I used 172.31.1.210

There is a Docker container available for installing the complete ROS workspace [here](https://github.com/MShields1986/kuka_kmr_iiwa_ws)

Edit and add the following to your .bashrc files...
```shell
# On Robot PC
. /opt/ros/noetic/setup.bash # Not needed for the Docker container
. /path_to_your/catkin_ws/devel/setup.bash # Not needed for the Docker container
export ROS_HOSTNAME=172.31.1.137
```

```shell
# Off Robot PC
. /opt/ros/noetic/setup.bash # Not needed for the Docker container
. /path_to_your/catkin_ws/devel/setup.bash # Not needed for the Docker container
export ROS_IP=172.31.2.210
export ROS_HOSTNAME=172.31.1.210
export ROS_MASTER_URI=http://172.31.1.137:11311
```

## Running the Demo
Note that the KMR will lock you out if it is in **Auto** and doesn't receive a `/cmd_vel` topic for ~10 seconds.

1. Turn the KMR on, once it boots set it to **T1** using the key on the teach pendant and turn the robot off again.

2. Turn the robot on and within 20 seconds establish the network connection from the "On Robot PC" and run...
```shell
# On Robot PC
roscore
```

3. Start the "Remote PC" and establish the network connection to the robot

4. In a new terminal run on the "On Robot PC"...
```shell
# On Robot PC
watch sudo chronyc -n clients
```

...and wait for ~30 seconds after seeing the remote PC and KMR connect to the NTP server.

5. Run the following command and check to see if there are any TF errors. If there are TF errors just wait a bit longer and try the command again. The TF errors are due to a lack of time synchronisation but they will stop once the clocks are aligned.
```shell
# On Robot PC
roslaunch vdbfusion_ros vdbfusion.launch config_file_name:=737_window_section.yaml
```

6. Now on the remote PC we can start the navigation...
```shell
# Remote PC
roslaunch kmr_iiwa_ifl_bringup real_kmr_bringup.launch
```

7. Once this is up you can put the robot into **Auto** and start the "ROSSmartServo" program on the iiwa using the teach pendant
8. Next perform some exploration of the map using the robot in order to have it get a good localisation estimate. Note that you may need to re-seed the initial estimate using RViz.
9. Now you are free to start all of the following servers...
```shell
# On Robot PC
roslaunch coupled_motion_controller init.launch
```

```shell
# On Robot PC
roslaunch noether_client init_simple.launch
```

```shell
# Remote PC
roslaunch view_planner view_plan.launch rviz:=false
```

```shell
# Remote PC
roslaunch eddyfi_ectane distributed_reconstruction.launch
```

10. Connect the camera to the USB port and run...
```shell
# On Robot PC
roslaunch fixture_tracker single_fixture.launch rviz:=false stand_alone:=false
```

#### EC Stuff


Finally to start the demo...
```shell
# Remote PC
roslaunch kmr_iiwa_ifl_behavior_tree init.launch
```
