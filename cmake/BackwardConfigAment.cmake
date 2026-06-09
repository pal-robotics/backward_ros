if (LIBDW_FOUND)
    add_definitions(-DBACKWARD_HAS_DW=1)
    set(backward_ros_forced_LIBRARIES "${backward_ros_LIBRARIES};${LIBDW_LIBRARIES}")
elseif(LIBBFD_FOUND)
    add_definitions(-DBACKWARD_HAS_BFD=1)
    set(backward_ros_forced_LIBRARIES "${backward_ros_LIBRARIES};${LIBBFD_LIBRARIES}")
else()
    set(backward_ros_forced_LIBRARIES "${backward_ros_LIBRARIES}")
endif()
#Hack to find absolute path to libraries, won't work if library is not compiled yet
foreach(lib ${backward_ros_forced_LIBRARIES})
    if(NOT EXISTS ${lib})
        message("${lib} doesn't exist, trying to find it in ${backward_ros_PREFIX}")
        find_library(backward_ros_lib_path 
            NAMES ${lib} 
            PATHS ${backward_ros_PREFIX})
        if(NOT ${backward_ros_lib_path})
            message("${lib} not found")
        else()
            message("${backward_ros_lib_path} found")
            set(backward_ros_full_path_LIBRARIES "${backward_ros_full_path_LIBRARIES} ${backward_ros_lib_path}")
        endif()
    else()
        set(backward_ros_full_path_LIBRARIES "${backward_ros_full_path_LIBRARIES} ${lib}")
    endif()
endforeach()
# The --no-as-needed/--as-needed flags are specific to the GNU/binutils
# linker. Other linkers (e.g. AppleClang's ld64 on macOS, or MSVC) do not
# understand them and would fail. Only emit them for the GNU toolchain.
set(no_as_needed)
set(as_needed)

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(no_as_needed "-Wl,--no-as-needed")
    set(as_needed "-Wl,--as-needed")
endif()

SET(CMAKE_EXE_LINKER_FLAGS "${no_as_needed} ${backward_ros_full_path_LIBRARIES} ${as_needed} ${CMAKE_EXE_LINKER_FLAGS}")

