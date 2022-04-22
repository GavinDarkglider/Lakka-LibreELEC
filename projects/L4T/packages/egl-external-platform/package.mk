# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="egl-external-platform"
PKG_VERSION="1.1"
PKG_SHA256="7c8f8e2218e46b1a4aa9538520919747f1184d86"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/NVIDIA/eglexternalplatform"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC=""
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  if [ ! -d "${SYSROOT_PREFIX}/usr/include/EGL" ]; then
    mkdir -p "${SYSROOT_PREFIX}/usr/include/EGL"
  fi
  cp interface/* ${SYSROOT_PREFIX}/usr/include/EGL
  sed -i "s|/usr/include/EGL|${SYSROOT_PREFIX}/usr/include/EGL|g" eglexternalplatform.pc
  if [ ! -d "${SYSROOT_PREFIX}/usr/lib/pkgconfig" ]; then
    mkdir -p "${SYSROOT_PREFIX}/usr/lib/pkgconfig"
  fi
  cp eglexternalplatform.pc ${SYSROOT_PREFIX}/usr/lib/pkgconfig/
}
