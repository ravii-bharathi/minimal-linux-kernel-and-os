#!/bin/bash
# Script outline to install and build kernel.


set -e
set -u

OUTDIR=/tmp/aeld
<<<<<<< HEAD
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
=======
KERNEL_REPO=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>>>>>>> production
KERNEL_VERSION=v5.15.163
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=/home/ravi/toolchain/arm-gnu-toolchain-14.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-

<<<<<<< HEAD
if [ $# -lt 1 ]
then
=======
if [ $# -lt 1 ]; then
>>>>>>> production
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

<<<<<<< HEAD
sudo mkdir -p ${OUTDIR}
=======
if ! sudo mkdir -p ${OUTDIR}; then
	echo "ERROR: Could not create output directory ${OUTDIR}"
	exit 1
fi
>>>>>>> production

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/linux-stable" ]; then
	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
    cd linux-stable
    echo "Checking out version ${KERNEL_VERSION}"
    git checkout ${KERNEL_VERSION}

#user code start for kernel build
	
	make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} mrproper
    	make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} defconfig
    	make -j$(nproc) ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} Image
<<<<<<< HEAD
    	cp arch/arm64/boot/Image "${OUTDIR}/Image"

fi

echo "Adding the Image in outdir"

echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ];
    	sudo rm  -rf ${OUTDIR}/rootfs
fi
	sudo mkdir -p "${OUTDIR}/rootfs"{/bin,/dev,/etc,/home,/lib,/proc,/sys,/tmp,/usr,/var}
	chmod 1777 "${OUTDIR}/rootfs/tmp"

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]
then
git clone https://git.busybox.net/busybox
    cd busybox
    git checkout ${BUSYBOX_VERSION}
=======
    	cp arch/${ARCH}/boot/Image "${OUTDIR}/Image"
<<<<<<<< HEAD:finder-app/manual-linux.sh
	cd ${OUTDIR}

fi

echo "INFO : KERNEL BUILD COMPLETE\n kernel image copied to ${OUTDIR}/Image"
========
	cd "$OUTDIR"
fi

echo "Kernel built and copied to ${OUTDIR}/Image"
>>>>>>>> production:manual-linux.sh

echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]; then
    	sudo rm  -rf ${OUTDIR}/rootfs
fi
<<<<<<<< HEAD:finder-app/manual-linux.sh

sudo mkdir -p "${OUTDIR}/rootfs"{/bin,/dev,/etc,/home,/lib,/lib64,/proc,/sys,/tmp,/usr,/var}
chmod 1777 "${OUTDIR}/rootfs/tmp"
========
    		sudo rm  -rf ${OUTDIR}/rootfs

sudo mkdir -p "${OUTDIR}/rootfs"{/bin,/dev,/etc,/home,/lib,/lib64,/proc,/sys,/tmp,/usr,/var}
sudo chmod 1777 "${OUTDIR}/rootfs/tmp"
>>>>>>>> production:manual-linux.sh

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]; then
	git clone https://git.busybox.net/busybox
    	cd busybox
	git checkout ${BUSYBOX_VERSION}
>>>>>>> production
else
    cd busybox
fi
make distclean
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} defconfig
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE}
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} CONFIG_PREFIX="${OUTDIR}/rootfs" install
<<<<<<< HEAD

echo "Library dependencies"
${CROSS_COMPILE}readelf -a ${OUTDIR}/bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a /bin/busybox | grep "Shared library"
=======
cd "${OUTDIR}"

echo "Library dependencies"
<<<<<<<< HEAD:finder-app/manual-linux.sh
${CROSS_COMPILE}readelf -a ${OUTDIR}/rootfs/bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a ${OUTDIR}/rootfs/bin/busybox | grep "Shared library"
========

${CROSS_COMPILE}readelf -a ${OUTDIR}/bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a /bin/busybox | grep "Shared library"
>>>>>>>> production:manual-linux.sh

echo "Library dependencies: searching for dependencies in ~/bin/busybox"

${CROSS_COMPILE}readelf -a ~/bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a ~/bin/busybox | grep "Shared library"
>>>>>>> production

# TODO: Add library dependencies to rootfs
SYSROOT=$(${CROSS_COMPILE}gcc --print-sysroot)

cp -a $SYSROOT/lib/ld-linux-aarch64.so.1 ${OUTDIR}/rootfs/lib/
cp -a $SYSROOT/lib/libc.so.6 ${OUTDIR}/rootfs/lib64/
cp -a $SYSROOT/lib/libm.so.6 ${OUTDIR}/rootfs/lib64/
<<<<<<< HEAD
=======
<<<<<<<< HEAD:finder-app/manual-linux.sh
cp -a $SYSROOT/lib64/libresolv.so.6 ${OUTDIR}/rootfs/lib64/
========
cp -a $SYSROOT/lib64/libresolv.s0.6 ${OUTDIR}/rootfs/lib64/


>>>>>>>> production:manual-linux.sh
>>>>>>> production

# TODO: Make device nodes

sudo mknod -m 666 ${OUTDIR}/rootfs/dev/null c 1 3
sudo mknod -m 622 ${OUTDIR}/rootfs/dev/console c 5 1

# TODO: Clean and build the writer utility

cd ~/repos/aeld-assignments/finder-app/
make clean
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE}
cp writer ${OUTDIR}/rootfs/home
<<<<<<< HEAD

# TODO: Copy the finder related scripts and executables to the /home directory

mkdir -p ${OUTDIR}/rootfs/home/finder-app
cp ~/repos/aeld-assignments/finder-app/* ${OUTDIR}/rootfs/home/finder-app/
=======
cd ..

# TODO: Copy the finder related scripts and executables to the /home directory

<<<<<<<< HEAD:finder-app/manual-linux.sh
mkdir -p ${OUTDIR}/rootfs/home/finder-app
sudo cp ~/repos/aeld-assignments/finder-app/finder.sh ${OUTDIR}/rootfs/home/
sudo cp ~/repos/aeld-assignments/conf/* ${OUTDIR}/rootfs/home/
sudo cp ~/repos/aeld-assignments/finder-app/finder-test.sh ${OUTDIR}/rootfs/home/
sudo cp ~/repos/aeld-assignments/autorun-qemu.sh ${OUTDIR}/rootfs/home/
========
sudo mkdir -p "${OUTDIR}/rootfs/home/finder-app"
cp -r ~/repos/aeld-assignments/conf/* ${OUTDIR}/rootfs/home/
cp -r  ~/repos/aeld-assignments/finder-app/* ${OUTDIR}/rootfs/home/finder-app/
cp ~/repos/aeld-assignments/autorun-qemu.sh ${OUTDIR}/rootfs/home/
>>>>>>>> production:manual-linux.sh
>>>>>>> production

# TODO: Chown the root directory

cd ${OUTDIR}/rootfs
sudo chown -R root:root *

# TODO: Create initramfs.cpio.gz

cd ${OUTDIR}/rootfs
find . | cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
gzip -f ${OUTDIR}/initramfs.cpio.gz

<<<<<<< HEAD
echo "process compelted"
=======
<<<<<<<< HEAD:finder-app/manual-linux.sh
echo "process compelted "
========
echo "process compelted. Output: ${OUTDIR}/Image and ${OUTDIR}/initramfs.cpio.gz"
>>>>>>>> production:manual-linux.sh
>>>>>>> production
