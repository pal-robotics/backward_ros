Backward ROS
============

For info about the backward-cpp project check https://github.com/bombela/backward-cpp

This wrapper should make it very easy to integrate backward_cpp into your ROS packages.

## ROS2

There's a foxy-devel branch and it has been released to the most recent ROS2 versions


## Integration of backward_ros

Add backward\_ros to your package.xml `<depend>backward_ros</depend>`

Add backward\_ros to your CMakeLists.txt `find_package(catkin REQUIRED COMPONENTS your_dependencies backward_ros)`


To get line numbers and more details, you need to build with debug information enabled (CMAKE_BUILD_TYPE = Debug or RelWithDebInfo)

You're done, it should automatically add a library to your executables, when they crash, they should print a nice stacktrace like this:
![pretty stackstrace](doc/pretty.png)
