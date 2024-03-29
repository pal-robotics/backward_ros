#
# CMakeLists.txt
# Copyright 2013 Google Inc. All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cmake_minimum_required(VERSION 3.5)
project(backward_ros)

include(cmake/BackwardConfig.cmake)

set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_STANDARD 11)

###############################################################################
# COMPILER FLAGS
###############################################################################

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_COMPILER_IS_GNUCXX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic-errors")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
endif()

###############################################################################
# BACKWARD OBJECT
###############################################################################
include_directories(include)

add_library(backward_object OBJECT src/backward.cpp)
target_compile_definitions(backward_object PRIVATE ${BACKWARD_DEFINITIONS})
target_include_directories(backward_object PRIVATE ${BACKWARD_INCLUDE_DIRS})
set(BACKWARD_ENABLE $<TARGET_OBJECTS:backward_object> CACHE STRING
        "Link with this object to setup backward automatically")


###############################################################################
# BACKWARD LIBRARY (Includes backward.cpp)
###############################################################################
option(BACKWARD_SHARED "Build dynamic backward-cpp shared lib" OFF)

if(BACKWARD_SHARED)
    set(libtype SHARED)
endif()
add_library(backward SHARED ${libtype} src/backward.cpp)
add_backward(backward)
target_compile_definitions(backward PUBLIC ${BACKWARD_DEFINITIONS})
target_include_directories(backward PUBLIC ${BACKWARD_INCLUDE_DIRS})

###############################################################################
# TESTS
###############################################################################

if(BACKWARD_TESTS)
        enable_testing()

        add_library(test_main SHARED test/_test_main.cpp)

        macro(backward_add_test src)
                get_filename_component(name ${src} NAME_WE)
                set(test_name "test_${name}")

                add_executable(${test_name} ${src} ${ARGN})

                target_link_libraries(${test_name} PRIVATE Backward::Backward test_main)

                add_test(NAME ${name} COMMAND ${test_name})
        endmacro()

        # Tests without backward.cpp
        set(TESTS
                test
                stacktrace
                rectrace
                select_signals
                )

        foreach(test ${TESTS})
                backward_add_test(test/${test}.cpp)
        endforeach()

        # Tests with backward.cpp
        set(TESTS
                suicide
                )

        foreach(test ${TESTS})
                backward_add_test(test/${test}.cpp ${BACKWARD_ENABLE})
        endforeach()
endif()

install(TARGETS backward
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(DIRECTORY include/
  DESTINATION include)

install(DIRECTORY cmake
        DESTINATION share/${PROJECT_NAME}
)

include(CMakePackageConfigHelpers)
set(BACKWARD_ROS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" CACHE PATH "backward_ros install prefix")
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION lib/cmake/${PROJECT_NAME}
    PATH_VARS BACKWARD_ROS_INSTALL_PREFIX
)


configure_file(cmake/BackwardConfig.cmake ${CMAKE_CURRENT_BINARY_DIR}/BackwardConfig.cmake @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/BackwardConfig.cmake DESTINATION share/${PROJECT_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake DESTINATION share/${PROJECT_NAME}/cmake)

include(CTest)
if(BUILD_TESTING)
  find_package(ament_lint_auto QUIET)
  if(ament_lint_auto_FOUND)
    ament_lint_auto_find_test_dependencies()
    ament_execute_extensions(ament_lint_auto)
  endif()
endif()


