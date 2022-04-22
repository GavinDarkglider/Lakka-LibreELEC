PKG_NAME="switch-joycon-bluetooth-dock-configs"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="joycond rewritefs"
if [ ${DISPLAYSERVER} = "x11" ]; then
  PKG_DEPENDS_TARGET+=" xdotool xrandr"
elif [ "${DISPLAYSERVER}" = "wl" ]; then
  PKG_DEPENDS_TARGET+=" wlr-randr"
fi
PKG_SECTION="virtual"
PKG_LONGDESC="Scripts for docking, and pairing joycons. Bluez config mount"

post_install() {
  if [ ${DISPLAYSERVER} = "x11" ]; then
    enable_service xorg-configure-switch.service
  fi
  enable_service var-bluetoothconfig.mount
  enable_service pair-joycon.service

  mkdir -p ${INSTALL}/usr/bin
  cp -Pv ${PKG_DIR}/scripts/pair-joycon.sh ${INSTALL}/usr/bin
  chmod +x ${INSTALL}/usr/bin/pair-joycon.sh

  if [ "${DISPLAYSERVER}" = "x11" ]; then
    cp -Pv ${PKG_DIR}/scripts/dock-hotplug ${INSTALL}/usr/bin
    chmod +x ${INSTALL}/usr/bin/dock-hotplug
  else
    #add dummy script for systemd with wayland build for now.
    echo '#!/bin/bash' >> ${INSTALL}/usr/bin/dock-hotplug
    chmod +x ${INSTALL}/usr/bin/dock-hotplug
  fi
}
