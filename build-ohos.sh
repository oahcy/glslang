#!/bin/bash

set -x
set -e

if [ $# -eq 0 ]; then
    # ARCH=x86
    # ARCH=x86_64
    # ARCH=armeabi-v7a
    ARCH=arm64-v8a
else
    ARCH=$1
fi

# LLVM_STRIP=$NDK_ROOT/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-strip.exe

BUILD_DIR=build-ohos-$ARCH
OHOS_SDK_ROOT=E:/work/harmonyos_data/ohos_sdk/native/3.2.7.5
LLVM_STRIP=$OHOS_SDK_ROOT/llvm/bin/llvm-strip.exe
rm -rf $BUILD_DIR/output

cmake -B $BUILD_DIR \
    -GNinja \
    -DCMAKE_TOOLCHAIN_FILE=$OHOS_SDK_ROOT/build/cmake/ohos.toolchain.cmake \
    -DOHOS_ARCH=$ARCH \
    -DANDROID_PLATFORM=android-19 \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_HLSL=OFF \
    -DENABLE_SPVREMAPPER=OFF \
    -DSKIP_GLSLANG_INSTALL=ON \
    -DSPIRV_SKIP_EXECUTABLES=ON

ninja -C $BUILD_DIR -v

mkdir $BUILD_DIR/output
find $BUILD_DIR -name "*.a" -exec $LLVM_STRIP --strip-debug {} \; -exec cp {} $BUILD_DIR/output \;

rm $BUILD_DIR/output/*SPIRV-Tools-link*
rm $BUILD_DIR/output/*SPIRV-Tools-reduce*