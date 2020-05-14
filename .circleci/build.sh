#!/usr/bin/env bash
echo "Cloning dependencies"
git clone --depth=1 https://github.com/dracarys18/NotKernel kernel
cd kernel
git clone --depth=1 https://github.com/arter97/arm64-gcc.git toolchain
git clone --depth=1 https://github.com/arter97/arm32-gcc.git toolchain32
git clone --depth=1 https://github.com/dracarys18/AnyKernel3.git Anykernel
echo "Done"
GCC="$(pwd)/toolchain/bin/aarch64-elf-"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
export CONFIG_PATH=$PWD/arch/arm64/configs/mido_defconfig
PATH="${PWD}/toolchain/bin:${PWD}/toolchain32/bin:${PATH}"
export CROSS_COMPILE_ARM32="$(pwd)/toolchain32/bin/arm-eabi-"
export CROSS_COMPILE="aarch64-elf-"
export ARCH=arm64
export KBUILD_BUILD_HOST=NotKernel
export KBUILD_BUILD_USER="root"
# sticker plox
function sticker() {
    curl -s -X POST "https://api.telegram.org/bot$token/sendSticker" \
        -d sticker="CAADBQADVAADaEQ4KS3kDsr-OWAUFgQ" \
        -d chat_id=$chat_id
}
# Send info plox channel
function sendinfo() {
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
        -d chat_id="$chat_id" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="<b>• NotKernel •</b>%0ABuild started on <code>Circle CI/CD</code>%0AFor device <b>Xiaomi Redmi note 4</b> (mido)%0Abranch <code>$(git rev-parse --abbrev-ref HEAD)</code>(master)%0AUnder commit <code>$(git log --pretty=format:'"%h : %s"' -1)</code>%0AUsing compiler: <code>$(${GCC}gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</code>%0AStarted on <code>$(date)</code>%0A<b>Build Status:</b> #Test"
}
# Push kernel to channel
function push() {
    cd Anykernel
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$token/sendDocument" \
        -F chat_id="$chat_id" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s). | For <b>Xiaomi Redmi Note 4 (mido)</b> | <b>$(${GCC}gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</b>"
}
# Fin Error
function finerr() {
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
        -d chat_id="$chat_id" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="Build is throwing  error(s)"
    exit 1
}
# Compile plox
function compile() {
    make O=out clean && make O=out mrproper && make O=out mido_defconfig
    make O=out -j$(nproc --all) 2>&1| tee build.log
    if ! [ -a $IMAGE ]; then
                finerr
                exit 1
   else
    cp $PWD/out/arch/arm64/boot/Image.gz-dtb $PWD/Anykernel/zImage
   fi 
}

# Zipping
function zipping() {
    cd Anykernel || exit 1
    zip -r9 NotKernel-Mido-${TANGGAL}.zip *
    cd .. 
}
sendinfo
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
push
