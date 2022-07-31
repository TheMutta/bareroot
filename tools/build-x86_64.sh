#!/bin/bash
set -e

# Purge environments
_PATH=$PATH
for env in `env` ; do
    name=${env/=*/}
    unset $name 2>/dev/null || true
done
export PATH=${_PATH}

# Get modules list
pool=(src/base/build.mk `find src -type f -iname build.mk | sort -V `)

# Initial directories
mkdir -p work/isoimage work/rootfs work/initramfs

# define variables
export OUTDIR="$(realpath work/out)"
export INITRAMFS="$(realpath work/initramfs)"
export DESTDIR="$(realpath work/rootfs)"

# Operations
for operation in fetch build install ; do
    i=0
    for pkg in ${pool[@]} ; do
        i=$(($i+1))
        module=$(basename $(dirname $pkg))
        mkdir -p "$OUTDIR/../$module"
        cd "$OUTDIR/../$module"
        if [[ ! -f .$operation ]] ; then
            echo -e "\033[32;1m$operation => $module\033[;0m"
            echo -e "\033]0;"[$i/${#pool[@]}] $operation: $module"\007"
            cp -prf $(dirname "../../$pkg*")/* .
            yes "" | make -f "../../$pkg" $operation OUTDIR=$OUTDIR INITRAMFS=$INITRAMFS DESTDIR=$DESTDIR
            touch .$operation
        fi
    done
    echo -e "\033[31;1mDONE: $operation\033[;0m"
    echo -e "\033]0;\007"
done
