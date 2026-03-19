# Minimal Linux Kernel Build + QEMU Emulation (ARM)

**Pre-silicon verification workflow**: Built minimal Linux kernel from source, 
configured device tree, and booted on QEMU ARM emulator. Demonstrates boot flow, 
kernel bring-up, and emulation debugging skills.

## Skills Demonstrated
- Linux kernel build from source
- Device tree configuration
- QEMU ARM emulation
- Bootloader → kernel → rootfs flow
- Pre-silicon bring-up and validation

## Tech Stack
- Linux kernel v6.x
- **QEMU** ARM64 emulation
- **BusyBox** rootfs
- Device tree overlays
- Cross-compilation toolchain

## How to Build & Run
```bash
# Clone and build
git clone https://github.com/yourusername/minimal-linux-kernel-qemu
cd linux
make ARCH=arm64 defconfig
make ARCH=arm64 qemu_arm64_defconfig
make -j$(nproc)

# Run in QEMU
qemu-system-aarch64 -M virt -cpu cortex-a57 -smp 1 -m 512M \
  -kernel arch/arm64/boot/Image -initrd rootfs.cpio.gz \
  -nographic -append "console=ttyAMA0"
