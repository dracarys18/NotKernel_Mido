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
REPACK_DIR=$KERNEL_DIR/zip
OUT=$KERNEL_DIR/out
export ARCH=arm64 && export SUBARCH=arm64
export CROSS_COMPILE="/home/jonsnow/NotKernel/toolchain/bin/aarch64-linux-android-"

rm -rf out
rm -rf zip
mkdir -p out
make O=out clean
make O=out mrproper
make O=out mido_defconfig
make O=out -j$(nproc --all)

if [ `ls "out/arch/arm64/boot/Image.gz-dtb" 2>/dev/null | wc -l` != "0" ]
then
git clone https://github.com/Yasir-siddiqui/AnyKernel3.git zip
cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/zImage
FINAL_ZIP="NotKernel-$(date +"%Y%m%d"-"%H%M").zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm zip/Image.gz-dtb


BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

cd out 
echo -e "Uploading $FINAL_ZIP to gdrive "
gdrive upload $FINAL_ZIP -p 12DlxhIySypF_ADSaF3s3xLGp8f9Z-MRF 

else
echo -e "Compilation failed fix it nubfuck"
exit 1
fi
