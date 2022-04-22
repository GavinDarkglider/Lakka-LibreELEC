# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="egl-wayland"
PKG_VERSION="1.1.9"
PKG_SHA256="cd0d19aa2742b1318527cabbcf279fb651c45d30"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/NVIDIA/egl-wayland"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain mesa"
PKG_LONGDESC=""
PROPPER_SYSROOT_PREFIX="${SYSROOT_PREFIX}"
echo $PROPPER_SYSROOT_PREFIX

pre_configure_target() {
  sed -i "s|prefix=@prefix@|prefix=${PROPPER_SYSROOT_PREFIX}/@prefix@|g" ../wayland-eglstream-protocols.pc.in
}

post_makeinstall_target() {
  if [ ! -d ${INSTALL}/usr/share/egl/egl_external_platform.d ]; then
   mkdir -p ${INSTALL}/usr/share/egl/egl_external_platform.d
  fi
  cp ${PKG_DIR}/assets/*.json ${INSTALL}/usr/share/egl/egl_external_platform.d/
}
