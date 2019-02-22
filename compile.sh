#!/bin/sh

ROOT_PATH=$PWD

# TG message

export CHAT_ID="348414952 $CHAT_ID";

function message()
{
for f in $CHAT_ID
do
bash ~/send_message.sh $f $@
done
}

message "Starting kernel compilation, [Progress URL]($BUILD_URL)."
rm -rf out
export KBUILD_BUILD_USER=alihasan7671
export KBUILD_BUILD_HOST=mark50
export USE_CCACHE=1

CCACHE=$(command -v ccache)

TOOLCHAIN=~/kernel/tchain/bin/aarch64-linux-android-

export CROSS_COMPILE="${CCACHE} ${TOOLCHAIN}"

export ARCH=arm64

make clean O=out/
make mrproper O=out/

make mido_defconfig O=out/

make -j8 O=out

# If successful

if [ `ls "out/arch/arm64/boot/Image.gz-dtb" 2>/dev/null | wc -l` != "0" ]
then
    echo Success
    rm ~/kernel/mkz/*gz-dtb
    rm ~/kernel/mkz/*.zip
    cp out/arch/arm64/boot/Image.gz-dtb ~/kernel/mkz
    cd ~/kernel/mkz
    zip -r9 "JARVIS-mido-$(date +"%Y%m%d"-"%H%M").zip" *
    KJZIP="$(ls JARVIS-mido-2019*.zip)";
    size=$(du -sh $KJZIP | awk '{print $1}')
    md5=$(md5sum $KJZIP | awk '{print $1}' )
    echo -e "${bldblu} Uploading ${txtrst}"
    message "Build successful, uploading now!";
    fileid=$(gdrive upload --parent 1H5llxFqCYVbda8uDB0sgNTZj1cVzVv5j ${KJZIP} | tail -1 | awk '{print $2}') 
    echo -e "${bldblu} Mirroring ${txtrst}"
    sudo rm /var/www/testbuilds.ialihasan.com/JARVIS-mido-*.zip
    sudo cp $KJZIP /var/www/testbuilds.ialihasan.com/
message @AliHasan7671 build completed %0AMD5sum - "$md5" %0ASize - "$size" %0A"[Gdrive link](https://drive.google.com/uc?id=$fileid) %0A[Mirror link](https://testbuilds.ialihasan.com/$KJZIP)"
    message "${POST_MESSAGE}";

# Else REEP
    else
    echo Failed.
    message "Build Failed."
fi
