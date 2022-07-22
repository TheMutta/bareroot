#!/bin/sh
qemu-system-i386 -m 32M -cdrom minimal_linux_live.iso -boot d -vga std -enable-kvm
