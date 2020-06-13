# Snippets/NVIDIA

## About
Assorted NVIDIA related patches.

General naming scheme is `kernel-[kernel version].patch`

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
$ wget https://download.nvidia.com/XFree86/Linux-x86_64/$VERSION/NVIDIA-Linux-x86_64-$VERSION.run
$ wget -O kernel-$KERNEL.patch https://gitlab.com/EULA/snippets/-/raw/master/NVIDIA/$VERSION/kernel-$KERNEL.patch
OR
$ wget -O kernel-$KERNEL.patch https://codeberg.org/EULA/Snippets/raw/branch/master/NVIDIA/$VERSION/kernel-$KERNEL.patch
$ sh NVIDIA-Linux-x86_64-$VERSION.run -x
$ cd NVIDIA-Linux-x86_64-$VERSION
$ patch -p1 -i ../kernel-$KERNEL.patch
# ./nvidia-installer
```
