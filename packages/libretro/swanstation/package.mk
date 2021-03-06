################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="swanstation"
PKG_VERSION="50a6a5e"
PKG_ARCH="x86_64 arm aarch64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/swanstation"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="SwanStation is an simulator/emulator of the Sony PlayStation(TM) console, focusing on playability, speed, and long-term maintainability."
PKG_LONGDESC="SwanStation is an simulator/emulator of the Sony PlayStation(TM) console, focusing on playability, speed, and long-term maintainability."
PKG_TOOLCHAIN="cmake-make"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$OPENGL_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" $OPENGL"
fi

if [ "$OPENGLES_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" $OPENGLES"
fi

if [ "$VULKAN_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" $VULKAN"
fi

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
                       -DUSE_DRMKMS=ON \
                       -DBUILD_LIBRETRO_CORE=ON"

# Compile with software renderer as default for devices not suporting OpenGL
if [ "$PROJECT" = "Generic" -o "$DEVICE" = "RPi4" -o "$DEVICE" = "Switch" ]; then
  PKG_PATCH_DIRS=""
else
  PKG_PATCH_DIRS="no_opengl"
fi


makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp swanstation_libretro.so $INSTALL/usr/lib/libretro/
}
