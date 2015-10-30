#!/bin/bash
# have ndk-build in your $PATH and the script figures out where your ANDROID_NDK is at
####################################################
# You do not need to modify anything below this line
####################################################
# find system torch, if not found, install it
command -v luajit -ltorch >/dev/null 2>&1
TORCHINSTALLCHECK=$?
if [ $TORCHINSTALLCHECK -ne 0 ]; then
    echo "Torch-7 not found on system. Please install it using instructions from http://torch.ch"
    exit -1
fi
# have ndk-build in your PATH and the script figures out where your ANDROID_NDK is at
unamestr=`uname`
ndkbuildloc=`which ndk-build`
if [[ "$unamestr" == 'Linux' ]]; then
    export ANDROID_NDK=`readlink -f $ndkbuildloc|sed 's/ndk-exec.sh//'|sed 's/ndk-build//'`
elif [[ "$unamestr" == 'Darwin' ]]; then
    brew install coreutils
    export ANDROID_NDK=`greadlink -f $ndkbuildloc|sed 's/ndk-exec.sh//'|sed 's/ndk-build//'`
fi
echo "Android NDK found at: $ANDROID_NDK"
cd "$(dirname "$0")" # switch to script directory
INSTALL_DIR=`pwd`
cd src
rm -rf build
mkdir -p build
cd build

cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DANDROID_STL=none -DCMAKE_BUILD_TYPE=Release -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.8 -DANDROID_NO_UNDEFINED=ON

CMAKERET=$?
if [ $CMAKERET -ne 0 ]; then
 echo "CMake error. Exiting."
 exit $CMAKERET
fi
make install -j4
MAKERET=$?
if [ $MAKERET -ne 0 ]; then
 echo "make error. Exiting."
 exit $MAKERET
fi
cd ../../

# copy libs
echo "Copying libraries"
rm -rf lib
mkdir -p lib
find ./src -name "*.a" -exec cp {} lib \;
echo "done"

# export lua sources
echo "exporting lua sources"
rm -rf share
mkdir -p share/lua/5.1/torch
cp -r src/pkg/torch/*.lua share/lua/5.1/torch/

mkdir -p share/lua/5.1/dok
cp -r src/pkg/dok/*.lua share/lua/5.1/dok/

mkdir -p share/lua/5.1/nn
cp -r src/3rdparty/nn/*.lua share/lua/5.1/nn/

mkdir -p share/lua/5.1/image
cp -r src/3rdparty/image/*.lua share/lua/5.1/image/

mkdir -p share/lua/5.1/audio
cp -r src/3rdparty/audio/*.lua share/lua/5.1/audio/

mkdir -p share/lua/5.1/nnx
cp -r src/3rdparty/nnx/*.lua share/lua/5.1/nnx/

mkdir -p share/lua/5.1/imgraph
cp -r src/3rdparty/imgraph/*.lua share/lua/5.1/imgraph/

mkdir -p share/lua/5.1/paths
cp -r src/3rdparty/paths/*.lua share/lua/5.1/paths/

mkdir -p share/lua/5.1/xlua
cp -r src/3rdparty/xlua/*.lua share/lua/5.1/xlua/

mkdir -p share/lua/5.1/sys
cp -r src/3rdparty/sys/*.lua share/lua/5.1/sys/

echo "done"

#remove cmake files in framework
echo "removing cmake files in framework"
rm -rf share/cmake
echo "done"
