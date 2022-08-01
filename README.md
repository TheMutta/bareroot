# Bareroot
Bareroot is a simple system to create a minimal Linux OS. It uses multiple  
submakefiles to flexibly compile all the needed packages.  

## Prerequisites
Make and bash are required, plus a gcc-compatible compiler and all the  
dependencies required for compiling the various modules.  

## Make
To compile everything and generate Linux, Initrd and Rootfs images for the  
x86_64 architecture just use the command `make build-x86_64`.  
The resulting images will be found in the `work/out` folder.

## Run
To do a test run, just run `make qemu-x86_64` script.
