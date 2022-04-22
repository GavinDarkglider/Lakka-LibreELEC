# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="tegra-udrm-gbm"
PKG_VERSION="v1.0.2"
PKG_SHA256="103d33d07e6c38106bf952403b336dc3ca809a08"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/OE4T/tegra-udrm-gbm"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain mesa:target egl-gbm tegra-bsp"
PKG_LONGDESC=""

PKG_MESON_OPTS_TARGET="-Dgbm-backends-path=${SYSROOT_PREFIX}/usr/lib/gbm"
PROPPER_SYSROOT_PREFIX=${SYSROOT_PREFIX}
post_makeinstall_target() {
  #Fix hacked lib path from build
  mv ${INSTALL}/${PROPPER_SYSROOT_PREFIX}/usr ${INSTALL}/
  rm -rf ${INSTALL}/${PROPPER_SYSROOT_PREFIX}

}
