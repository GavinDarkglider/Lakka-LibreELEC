PKG_NAME="libretro_database"
PKG_VERSION="0d2369662205f6d01c22768d4b5b466cd7968f24"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-database"
PKG_URL="${PKG_SITE}.git"
PKG_LONGDESC="Repository containing cheatcode files, content data files, etc."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  make -C ${PKG_BUILD} install INSTALLDIR="${INSTALL}/usr/share/libretro-database"
}
