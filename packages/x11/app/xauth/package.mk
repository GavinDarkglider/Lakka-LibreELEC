# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="xauth"
PKG_VERSION="1.0.10"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/app/xauth/-/archive/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain util-macros libXau libX11 libXext libXmu"
PKG_LONGDESC="Creates/manages Xauthotity files"
PKG_TOOLCHAIN="autotools"

#pre_configure() {
#  ./autogen.sh
#}
#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin/xkeystone
#}
