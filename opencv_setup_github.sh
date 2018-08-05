#!/bin/bash

VERSION=github

rm -rf opencv_build_$VERSION
mkdir opencv_build_$VERSION
cd opencv_build_$VERSION 

git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

mkdir build
cd build

cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ../opencv

make -j4

