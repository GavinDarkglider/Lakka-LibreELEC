PKG_NAME="beetle_lynx"
PKG_VERSION="2941d8c0c5ba342b6e7bd7d431e8f9c5a6d5c2c9"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-lynx-libretro"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen Lynx"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v mednafen_lynx_libretro.so ${INSTALL}/usr/lib/libretro/
}
