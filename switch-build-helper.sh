
if [ "${1}" = "debug" ]; then
export DEBUG=all
fi

rm target/*

export DISTRO=Lakka
export PROJECT=L4T
export DEVICE=Switch
export ARCH=aarch64

make -j16 image

unset DEBUG
unset DISTRO
unset PROJECT
unset DEVICE
unset ARCH
