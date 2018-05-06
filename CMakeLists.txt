cmake_minimum_required(VERSION 2.8.7)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules")
set(CMAKE_D_COMPILER ldc2)

project(twitterbot D)

set(SRC_DIR src)
set(SRC_FILES ${SRC_DIR}/test.d
${SRC_DIR}/twitter4d.d)
include_directories(${SRC_DIR})

add_executable(${PROJECT_NAME} ${SRC_FILES})