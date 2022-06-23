#!/bin/sh
qemu-system-x86_64 -m 512M -cdrom minimal_linux_live.iso -boot d -vga std -enable-kvm
