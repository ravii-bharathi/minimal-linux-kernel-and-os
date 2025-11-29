#!/bin/bash
# Script to build kernel and rootfs for AELD assignment 3

set -e
set -u

OUTDIR=/tmp/aeld
KERNEL_REPO="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_VERSION="v5.15.163"
BUSYBOX_VERSION="1_33_1"
ARCH=arm64
CROSS_COMPILE="/home/ravi/toolchain/arm-gnu-toolchain-14.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"

# Handle OUTDIR argument
if [ $# -lt 1 ]; then
    echo "Using default directory ${OUTDIR} for output"
else
    OUTDIR="$1"
    echo "Using passed directory ${OUTDIR} for output"
fi

# Create OUTDIR
if ! sudo mkdir -p "${OUTDIR}"; then
    echo "ERROR: Could not create output directory ${OUTDIR}"
    exit 1
fi

cd "${OUTDIR}"

#######################
# 1. Build Linux kernel
#######################
if [ ! -d "${OUTDIR}/linux-stable" ]; then
    echo "Cloning Linux stable ${KERNEL_VERSION} into ${OUTDIR}"
    git clone "${KERNEL_REPO}" --depth 1 --single-branch --branch "${KERNEL_VERSION}" linux-stable
fi

if [ ! -e "${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image" ]; then
    cd linux-stable
    echo "Checking out kernel version ${KERNEL_VERSION}"
    git checkout "${KERNEL_VERSION}"

    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} mrproper
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} defconfig
    make -j"$(nproc)" ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} Image

    cp "arch/${ARCH}/boot/Image" "${OUTDIR}/Image"
    cd "${OUTDIR}"
else
    cp "linux-stable/arch/${ARCH}/boot/Image" "${OUTDIR}/Image"
fi

echo "INFO: Kernel build complete. Kernel image copied to ${OUTDIR}/Image"

###################################
# 2. Create rootfs staging directory
###################################
echo "Creating the staging directory for the root filesystem"

if [ -d "${OUTDIR}/rootfs" ]; then
    sudo rm -rf "${OUTDIR}/rootfs"
fi

sudo mkdir -p "${OUTDIR}/rootfs"/{bin,dev,etc,home,lib,lib64,proc,sys,tmp,usr,var}
sudo chmod 1777 "${OUTDIR}/rootfs/tmp"

########################
# 3. Build and install BusyBox
########################
cd "${OUTDIR}"

if [ ! -d "${OUTDIR}/busybox" ]; then
    git clone https://git.busybox.net/busybox
    cd busybox
    git checkout "${BUSYBOX_VERSION}"
else
    cd busybox
fi

make distclean
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} defconfig
make -j"$(nproc)" ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} CONFIG_PREFIX="${OUTDIR}/rootfs" install

echo "Library dependencies for busybox:"
${CROSS_COMPILE}readelf -a "${OUTDIR}/rootfs/bin/busybox" | grep "program interpreter" || true
${CROSS_COMPILE}readelf -a "${OUTDIR}/rootfs/bin/busybox" | grep "Shared library" || true

########################
# 4. Copy library dependencies
########################
SYSROOT=$(${CROSS_COMPILE}gcc --print-sysroot)

# Adjust paths if your toolchain keeps them elsewhere
sudo cp -a "/usr/aarch64-linux-gnu/lib/ld-linux-aarch64.so.1" "${OUTDIR}/rootfs/lib/"
sudo cp -a "/usr/aarch64-linux-gnu/lib/libc.so.6"          "${OUTDIR}/rootfs/lib64/"
sudo cp -a "/usr/aarch64-linux-gnu/lib/libm.so.6"          "${OUTDIR}/rootfs/lib64/"
sudo cp -a "/usr/aarch64-linux-gnu/lib/libresolv.so.2"     "${OUTDIR}/rootfs/lib64/"

########################
# 5. Create device nodes
########################
sudo mknod -m 666 "${OUTDIR}/rootfs/dev/null"    c 1 3
sudo mknod -m 622 "${OUTDIR}/rootfs/dev/console" c 5 1

########################
# 6. Build writer and copy scripts
########################
cd /home/ravi/repos/aeld-assignments/finder-app/

make clean
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
cp writer "${OUTDIR}/rootfs/home/"

# Create home/finder-app and copy app plus configs
sudo mkdir -p "${OUTDIR}/rootfs/home/finder-app"
sudo cp finder.sh                       "${OUTDIR}/rootfs/home/"
sudo cp finder-test.sh                  "${OUTDIR}/rootfs/home/"
sudo cp ~/repos/aeld-assignments/conf/* "${OUTDIR}/rootfs/home/"
sudo cp ~/repos/aeld-assignments/autorun-qemu.sh "${OUTDIR}/rootfs/home/"
sudo cp -r ./*                          "${OUTDIR}/rootfs/home/finder-app/"

########################
# 7. Chown rootfs to root
########################
cd "${OUTDIR}/rootfs"
sudo chown -R root:root *

########################
# TODO: Create initramfs.cpio.gz
########################

cd ${OUTDIR}/rootfs
find . | cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
gzip -f ${OUTDIR}/initramfs.cpio.gz

echo "process compelted"
echo "process compelted "
echo "process compelted. Output: ${OUTDIR}/Image and ${OUTDIR}/initramfs.cpio.gz"
