# Snippets/NVIDIA

## About
Assorted NVIDIA related patches.

General naming scheme is kernel-[version]-[driver version].patch

## How to
Replace `$VERSION` with the NVIDIA version you're patching, and `$KERNEL` with, well, the kernel version being targeted.

### Extract Driver & Patch
```raw
$ sh NVIDIA-Linux-x86_64-$VERSION.run -x
$ cd NVIDIA-Linux-x86_64-$VERSION
$ patch -p1 -i kernel-$KERNEL.patch
```

### Patch & Run NVIDIA Installer
```raw
$ wget http://us.download.nvidia.com/XFree86/Linux-x86_64/$VERSION/NVIDIA-Linux-x86_64-$VERSION.run
$ wget -O kernel-$KERNEL.patch https://gitlab.com/EULA/snippets/-/raw/master/NVIDIA/kernel-$KERNEL-$VERSION.patch
OR
$ wget -O kernel-$KERNEL.patch https://codeberg.org/EULA/Snippets/raw/branch/master/NVIDIA/kernel-$KERNEL-$VERSION.patch
$ sh NVIDIA-Linux-x86_64-$VERSION.run -x
$ cd NVIDIA-Linux-x86_64-$VERSION
$ patch -p1 -i ../kernel-$KERNEL.patch
# ./nvidia-installer
```
