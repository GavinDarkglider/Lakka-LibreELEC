PKG_NAME="glsl_shaders"
PKG_VERSION="2a20d90ee3eaf943c67e7b5cdf2ce4b26f460e8d"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/libretro/glsl-shaders"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="gcc:host"
PKG_LONGDESC="GLSL shaders converted by hand from libretro's common-shaders repo."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  cd ${PKG_BUILD}
  make install INSTALLDIR="${INSTALL}/usr/share/retroarch/shaders/GLSL-Shaders"
}

