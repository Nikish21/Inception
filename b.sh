#!/bin/bash
#



# Init Script
KERNEL_DIR=$PWD
KERNEL="Image.gz"
DTB="trinket.dtb"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz
KERN_DTB=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/trinket.dtb
BUILD_START=$(date +"%s")
BASE_VER="Inception"
KERNEL_VER=v4n2
ANYKERNEL_DIR=/home/ubuntu/anykernel
EXPORT_DIR=/home/ubuntu/zips
file=$PWD/b.sh
FINAL_ZIP=$BASE_VER-v$KERNEL_VER.zip

# Release
VER="$KERNEL_VER-$(date +"%Y-%m-%d"-%H%M)-"


# Color Code Script
black='\e[0;30m'        # Black
red='\e[0;31m'          # Red
green='\e[0;32m'        # Green
yellow='\e[0;33m'       # Yellow
blue='\e[0;34m'         # Blue
purple='\e[0;35m'       # Purple
cyan='\e[0;36m'         # Cyan
white='\e[0;37m'        # White
nocol='\033[0m'         # Default

# Tweakable Stuff
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Nikish21"
export KBUILD_BUILD_HOST="ndpc"
export CC=/home/ubuntu/proton-clang/bin/clang
export CROSS_COMPILE=/home/ubuntu/proton-clang/bin/aarch64-linux-gnu-
#COMPILATION SCRIPTS
echo -e "${green}"
echo "--------------------------------------------------------"
echo "      Initializing build to compile Ver: $VER    "
echo "--------------------------------------------------------"

echo -e "$cyan***********************************************"
echo "         Creating Output Directory: out      "
echo -e "***********************************************$nocol"

mkdir -p out


make O=out clean
make O=out mrproper

echo -e "$cyan***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************$nocol"

make O=out ARCH=arm64 vendor/ginkgo-perf_defconfig

echo -e "$cyan***********************************************"
echo "          Providing The Inception        "
echo -e "***********************************************$nocol"

make -j$(nproc --all) O=out ARCH=arm64 \
                CC=$CC \
                CROSS_COMPILE=$CROSS_COMPILE \





# If compilation was successful

echo -e "$green***********************************************"
echo "          Copying Image.gz    "
echo -e "***********************************************$nocol"

mv out/arch/arm64/boot/Image.gz $ANYKERNEL_DIR/kernel/

echo -e "$green***********************************************"
echo "          Copying dtb    "
echo -e "***********************************************$nocol"

mv out/arch/arm64/boot/dts/qcom/trinket.dtb $ANYKERNEL_DIR/dtbs/

echo -e "$green***********************************************"
echo "          Copied Successfully        "
echo -e "***********************************************$nocol"

echo -e "$green***********************************************"
echo "          Making Flashable Zip        "
echo -e "***********************************************$nocol"

cd $ANYKERNEL_DIR

zip -r9 $FINAL_ZIP *

echo -e "$green***********************************************"
echo "          Copying Final ZIP to flashable files folder        "
echo -e "***********************************************$nocol"

mv $FINAL_ZIP $EXPORT_DIR






# BUILD TIME
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$cyan Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

# END
