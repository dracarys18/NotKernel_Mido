#!/bin/bash
#


tput reset
echo -e "==============================================="
echo    "         Compiling NotKernel                   "
echo -e "==============================================="

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/NotKernel_zip
OUT=$KERNEL_DIR/out
export ARCH=arm64 && export SUBARCH=arm64
export CROSS_COMPILE="/home/jonsnow/notkernel/toolchain/bin/aarch64-linux-android-"

rm -rf out
mkdir -p out
make O=out clean
make O=out mrproper
make O=out mido_defconfig
make O=out -j$(nproc --all)

cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
FINAL_ZIP="NotKernel-$(date +"%Y%m%d"-"%H%M").zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm zip/Image.gz-dtb

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

