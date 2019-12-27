#!/usr/bin/env bash
apt-get update -y
 apt-get install -y ccache bc bash git-core gnupg build-essential zip curl make automake autogen autoconf autotools-dev libtool shtool python m4 gcc libtool zlib1g-dev dash 
cd /
git clone  https://github.com/CurioussX13/NotKernel.git -b pie mido --depth 1
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r20 gcc32 --depth 1 
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-10.0.0_r20 gcc --depth 1
git clone https://github.com/CurioussX13/AnyKernel3.git -b mido ak3 
IMAGE=/mido/out/arch/arm64/boot/Image.gz-dtb

out=/mido/out
date=`date +"%Y%m%d-%H%M"`
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=/gcc/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/gcc32/bin/arm-linux-androideabi-
key=$(openssl enc -base64 -d <<< OTk0MzkyMzY3OkFBRk9ZUS04aXZKUklLQTR2MEJQTGJuV3B0M1hWejNJSXFz )
id=$(openssl enc -base64 -d <<< LTEwMDEzMTM2MDAxMDY= )
function bot_env() {
TELEGRAM_KERNEL_VER=$(cat /mido/out/.config | grep Linux/arm64 | cut -d " " -f3)
TELEGRAM_UTS_VER=$(cat /mido/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TELEGRAM_COMPILER_NAME=$(cat /mido/out/include/generated/compile.h | grep LINUX_COMPILE_BY | cut -d '"' -f2)
TELEGRAM_COMPILER_HOST=$(cat /mido/out/include/generated/compile.h | grep LINUX_COMPILE_HOST | cut -d '"' -f2)
TELEGRAM_TOOLCHAIN_VER=$(cat /mido/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
}

function info() {
    curl -s -X POST https://api.telegram.org/bot$key/sendMessage -d chat_id=$id -d "parse_mode=HTML" -d text="$(
            for POST in "${@}"; do
                echo "${POST}"
            done
        )" 
&>/dev/null
}
 function cs() {
info   "<b>Kernel build Start!</b>" \
              "" \
              "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1) </code>"
}
function cc() {
bot_env
info "<b>Kernel Version:</b><code> Linux ${TELEGRAM_KERNEL_VER}</code>" \
    "" \
    "<b>Kernel Host:</b><code> ${TELEGRAM_COMPILER_NAME}@${TELEGRAM_COMPILER_HOST}</code>" \
    "" \
    "<b>Kernel Toolchain :</b><code> ${TELEGRAM_TOOLCHAIN_VER}</code>" \
    "" \
    "<b>UTS Version :</b><code> ${TELEGRAM_UTS_VER}</code>" \
    "" \
    "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1)</code>" \
    "" \
    "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>" 
}
    function bs() {
  info  "<b>Kernel build Success!</b>" 
            
         
}
function bf(){
 info "<b>Clarity Kernel build Failed!</b>" \
              "" \
              "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>"
}

   function compile() { 
cd mido
cs
 START=$(date +"%s")
 make  O=out ARCH=arm64 mido_defconfig
make -j32 O=out  -> compile.log
if ! [ -a $IMAGE ]; then
                
                END=$(date +"%s")
                DIFF=$(($END - $START))
                bf
		curl -F chat_id=$id -F document="@/mido/compile.log" https://api.telegram.org/bot$key/sendDocument
                exit 1
fi
        END=$(date +"%s")
        DIFF=$(($END - $START))
        bs
cp ${IMAGE} /ak3/zImage
cd /ak3
FZ="CustKernel-$(date +"%Y%m%d"-"%H%M").zip"
zip -r9 "${FZ}" *
cp *.zip $out
cc
curl -F chat_id=$id -F document="@/mido/out/${FZ}"  https://api.telegram.org/bot$key/sendDocument
curl -F chat_id=$id -F document="@/mido/compile.log" https://api.telegram.org/bot$key/sendDocument
git --no-pager log --pretty=format:"%h - %s (%an)" --abbrev-commit ${COMMIT}..HEAD > git-changelog.log
	curl -F chat_id=$id -F document="@git-changelog.log" https://api.telegram.org/bot$key/sendDocument &>/dev/null



}
compile
