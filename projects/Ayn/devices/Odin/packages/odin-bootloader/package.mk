PKG_NAME="odin-bootloader"
PKG_VERSION="1.0"
PKG_ARCH="any"
PKG_DEPENDS_TARGET=""
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/bootloader/boot/
  cp -Prv ${PKG_DIR}/files/boot/* ${INSTALL}/usr/share/bootloader/boot/
}
