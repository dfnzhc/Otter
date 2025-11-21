cmake_minimum_required(VERSION 4.0)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CUDA_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS ON)

set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

project(Otter
        LANGUAGES CXX C
        VERSION 0.0.1)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMake")

# --------------------------------------------------------------
# Global settings
# --------------------------------------------------------------

set(OTT_BUILD_TESTS ON CACHE BOOL "Build test programs")

set(OTT_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Include)

include(HelperScripts)

# --------------------------------------------------------------
# Sources
# --------------------------------------------------------------

add_subdirectory(Source)
add_subdirectory(Tests)