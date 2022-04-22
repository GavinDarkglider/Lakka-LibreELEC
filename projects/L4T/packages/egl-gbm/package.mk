# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="egl-gbm"
PKG_VERSION="1.1.0"
PKG_SHA256="39932b2cc4f44cdadd553cc931f3bebd4e348d10"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/NVIDIA/egl-gbm"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain egl-external-platform:host mesa"
PKG_LONGDESC=""

post_makeinstall_target() {
  if [ ! -d ${INSTALL}/usr/share/egl/egl_external_platform.d ]; then
   mkdir -p ${INSTALL}/usr/share/egl/egl_external_platform.d
  fi
  cp ${PKG_DIR}/assets/nvidia_gbm.json ${INSTALL}/usr/share/egl/egl_external_platform.d/
}
