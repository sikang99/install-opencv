#
# Makefile for OpenCV
#
all: usage

VERSION=3.4.2

usage:
	@echo ""
	@echo "usage: make [0|1|2|3|4|5|6|7|ubuntu]"
	@echo "	- 0 : clean"
	@echo "	- 1 : prepare"
	@echo "	- 2 : download"
	@echo "	- 3 : unzip"
	@echo "	- 4 : configure"
	@echo "	- 5 : build"
	@echo "	- 6 : install"
	@echo "	- 7 : check"
	@echo ""

#-------------------------------------------------------------------------------
edit-readme er:
	vi README.md

edit-make em:
	vi Makefile

#-------------------------------------------------------------------------------
purge:
	sudo apt-get purge libopencv* python-opencv
	sudo apt-get autoremove

0 clean:
	rm -rf opencv-$(VERSION) opencv_contrib-$(VERSION) build
	mkdir build && ls -al build
	@echo "> make 1 stage"

1 prepare:
	sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
	sudo apt install ubuntu-restricted-extras
	sudo apt install build-essential cmake
	sudo apt install pkg-config
	sudo apt install libjpeg-dev libtiff5-dev libpng-dev
	sudo apt install libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev
	sudo apt install libv4l-dev v4l-utils
	sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
	sudo apt install libgtk2.0-dev
	sudo apt install mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev
	sudo apt install libatlas-base-dev gfortran libeigen3-dev
	sudo apt install python2.7-dev python3-dev python-numpy python3-numpy
	@echo "> make 2 stage"

# opencv 3.4.2
2 download:
	@wget -O opencv-$(VERSION).zip https://github.com/opencv/opencv/archive/$(VERSION).zip
	@wget -O opencv_contrib-$(VERSION).zip https://github.com/opencv/opencv_contrib/archive/$(VERSION).zip
	@mv *.zip bak/
	@ls -alF bak/
	@echo "> make 3 stage"

3 unzip:
	@unzip bak/opencv-$(VERSION).zip
	@unzip bak/opencv_contrib-$(VERSION).zip
	@ls -alF
	@echo "> make 4 stage"

4 configure:
	cd build && \
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D WITH_TBB=OFF \
	-D WITH_IPP=OFF \
	-D WITH_1394=OFF \
	-D BUILD_WITH_DEBUG_INFO=OFF \
	-D BUILD_DOCS=OFF \
	-D INSTALL_C_EXAMPLES=ON \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D BUILD_EXAMPLES=OFF \
	-D BUILD_TESTS=OFF \
	-D BUILD_PERF_TESTS=OFF \
	-D WITH_QT=OFF \
	-D WITH_GTK=ON \
	-D WITH_OPENGL=ON \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$(VERSION)/modules \
	-D WITH_V4L=ON  \
	-D WITH_FFMPEG=ON \
	-D WITH_XINE=ON \
	-D BUILD_NEW_PYTHON_SUPPORT=ON \
	../opencv-$(VERSION) 2>&1 | tee cmake_messages.txt
	@echo "> make 5 stage"

5 build:
	nproc
	cd build && make -j4 2>&1 | tee build_messages.txt
	@echo "> make 6 stage"

6 install:
	sudo make install
	sudo ldconfig
	@echo "> make 7 stage"

7 check:
	pkg-config --modversion opencv

#-------------------------------------------------------------------------------
build-github:
	mkdir opencv_build
	cd opencv_build && git clone https://github.com/opencv/opencv.git
	cd opencv_build && git clone https://github.com/opencv/opencv_contrib.git
	cd opencv_build && mkdir build
	cd opencv_build/build && \
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ../opencv
	cd opencv_build/build && make -j4 

#-------------------------------------------------------------------------------
ubuntu u:
	@echo ""
	@echo "make (ubuntu) [install|remove]"
	@echo ""

# openv 3.2.0 version in ubuntu 18.04
ubuntu-install ui:
	sudo apt install -y libopencv-core-dev libopencv-contrib-dev python3-opencv

ubuntu-remove ur:
	sudo apt remove -y libopencv-core-dev libopencv-contrib-dev python3-opencv

#-------------------------------------------------------------------------------
git-init gi:
	rm -rf .git/
	echo "# install-opencv" >> README.md
	git init
	git add README.md
	git commit -m "first commit"
	git remote add origin https://github.com/sikang99/install-opencv.git
	git push -u origin master

git-update gu:
	git add Makefile README.md *.sh
	#git commit -m "modify contents"
	git commit -m "add shell scripts"
	git push

#-------------------------------------------------------------------------------

