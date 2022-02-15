PKG_NAME="fceumm"
PKG_VERSION="acfab9f61d009a10fc717d2039aab9aa78fe2556"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/libretro-fceumm"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of FCEUmm / FCEUX to Libretro."
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-f Makefile.libretro"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v fceumm_libretro.so ${INSTALL}/usr/lib/libretro/
}
