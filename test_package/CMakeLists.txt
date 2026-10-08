project(backward-package-test)
cmake_minimum_required(VERSION 3.10)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
include(${CONAN_CMAKE-UTILS_ROOT}/conan.cmake)
conan_basic_setup()

add_conan_library(backward)

add_executable(example main.cpp)
target_link_libraries(example PRIVATE backward-conan)
