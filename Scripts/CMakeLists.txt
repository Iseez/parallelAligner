cmake_minimum_required(VERSION 3.17)
project(Scripts)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(Scripts
        main.cpp
        matrix.cpp
        matrix.h
        reader.cpp
        reader.h)
