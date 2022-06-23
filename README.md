# Bareroot
A simple script that creates a minimal functional Linux OS.

## Prerequisites
Musl is required to compile Busybox and the Linux kernel, but it may be substituted with glibc.
To do a test run, qemu is required.

## Make
Just run `clean.sh` to clean the directory (otherwise compilation will not work).
Then, run the compilation with `minimal.sh`.

## Run
To do a test run, just run the `qemu64.sh` script.
