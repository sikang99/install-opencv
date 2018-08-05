#1/bin/bash

VERSION=3.4.0
# [Ubuntu 18.04 에서 OpenCV 설치하기](http://kkokkal.tistory.com/1328)

# Optional. Ubuntu 18.04에서 libjasper-dev 패키지를 설치하기 위해서 저장소를 추가해야 합니다.
$ sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"

$ sudo apt update
$ sudo apt upgrade

# Optional. Ubuntu 18.04 설치 후 추가적으로 필요한 코덱, 미디어 라이브러리를 설치합니다.
$ sudo apt install ubuntu-restricted-extras

# Build tools & required
$ sudo apt install build-essential cmake git pkg-config

# For still images
$ sudo apt install libjpeg-dev libtiff5-dev libjasper-dev libpng-dev

# For videos
$ sudo apt install libavcodec-dev libavformat-dev libswscale-dev
$ sudo apt install libdc1394-22-dev libxvidcore-dev libx264-dev x264
$ sudo apt install libxine2-dev libv4l-dev v4l-utils
$ sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# GUI
$ sudo apt install libgtk-3-dev

# Optimization, Python3, etc.
$ sudo apt install libatlas-base-dev libeigen3-dev gfortran
$ sudo apt install python3-dev python3-numpy libtbb2 libtbb-dev

# Create a working directory named opencv
#$ cd ~
$ mkdir opencv
$ cd opencv

# Download sources
$ wget -O opencv-$(VERSION).zip https://github.com/opencv/opencv/archive/$(VERSION).zip
$ wget -O opencv_contrib-$(VERSION).zip https://github.com/opencv/opencv_contrib/archive/$(VERSION).zip

# Unpack
$ unzip opencv-$(VERSION).zip
$ unzip opencv_contrib-$(VERSION).zip

# Create a build directory
$ mkdir build && cd build

# Run CMake
$ cmake \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D BUILD_WITH_DEBUG_INFO=OFF \
-D BUILD_EXAMPLES=ON \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-$(VERSION)/modules \
-D WITH_TBB=ON \
-D WITH_V4L=ON \
../opencv-$(VERSION)/ 2>&1 | tee cmake_messages.txt

# find out the number of CPU cores in your machine
$ nproc

# substitute 2 after -j by the output of nproc
$ make -j2 2>&1 | tee build_messages.txt
$ sudo make install
$ sudo ldconfig

# If the output of next command is '3.4.0' then it's ok!
$ pkg-config --modversion opencv


