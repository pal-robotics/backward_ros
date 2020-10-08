Backward ROS
============

For info about the backward-cpp project check https://github.com/bombela/backward-cpp

This wrapper should make it very easy to integrate backward_cpp into your ROS2 packages.

## Integration of backward_ros

Add backward\_ros to your package.xml `<depend>backward_ros</depend>`

Add backward\_ros to your CMakeLists.txt `find_package(backward_ros REQUIRED)`

You're done, it should automatically add a library to your executables, when they crash, they should print a nice stacktrace like this:
![pretty stackstrace](doc/pretty.png)



To get line numbers and more details, you need to build with debug information enabled (CMAKE_BUILD_TYPE = Debug or RelWithDebInfo)