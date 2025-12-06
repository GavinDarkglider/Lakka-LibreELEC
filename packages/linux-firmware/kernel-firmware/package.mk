# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="kernel-firmware"
PKG_VERSION="20250509"
PKG_SHA256="f2c60d66f226a28130cb5643e6e544d3229673460e127c91ba03f1080cbd703e"
PKG_LICENSE="other"
PKG_SITE="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/"
PKG_URL="https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${PKG_VERSION}.tar.xz"
PKG_NEED_UNPACK="${PROJECT_DIR}/${PROJECT}/packages/${PKG_NAME} ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/packages/${PKG_NAME}"
PKG_LONGDESC="kernel-firmware: kernel related firmware"
PKG_TOOLCHAIN="manual"

configure_package() {
  PKG_FW_SOURCE=${PKG_BUILD}/.copied-firmware
}

post_patch() {
  (
    cd ${PKG_BUILD}

    # Do not run check_whence.py against the copied firmware
    echo '#!/usr/bin/python3' > check_whence.py

    mkdir -p "${PKG_FW_SOURCE}"
      ./copy-firmware.sh --verbose "${PKG_FW_SOURCE}"
  )
}

# Install additional miscellaneous drivers
makeinstall_target() {
  FW_TARGET_DIR=${INSTALL}/$(get_full_firmware_dir)

  if find_file_path config/kernel-firmware.dat; then
    FW_LISTS="${FOUND_PATH}"
  else
    FW_LISTS="${PKG_DIR}/firmwares/any.dat ${PKG_DIR}/firmwares/${TARGET_ARCH}.dat"
  fi

  FW_LISTS+=" ${PROJECT_DIR}/${PROJECT}/config/kernel-firmware-any.dat ${PROJECT_DIR}/${PROJECT}/config/kernel-firmware-${TARGET_ARCH}.dat"

  FW_LISTS+=" ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/config/kernel-firmware-any.dat ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/config/kernel-firmware-${TARGET_ARCH}.dat"

  for fwlist in ${FW_LISTS}; do
    [ -f "${fwlist}" ] || continue

    while read -r fwline; do
      [ -z "${fwline}" ] && continue
      [[ ${fwline} =~ ^#.* ]] && continue
      [[ ${fwline} =~ ^[[:space:]] ]] && continue

      eval "(cd ${PKG_FW_SOURCE} && find "${fwline}" >/dev/null)" || die "ERROR: Firmware pattern does not exist: ${fwline}"

      while read -r fwfile; do
        [ -d "${PKG_FW_SOURCE}/${fwfile}" ] && continue

        if [ -f "${PKG_FW_SOURCE}/${fwfile}" ]; then
          mkdir -p "$(dirname "${FW_TARGET_DIR}/${fwfile}")"
            cp -Lv "${PKG_FW_SOURCE}/${fwfile}" "${FW_TARGET_DIR}/${fwfile}"
        else
          echo "ERROR: Firmware file ${fwfile} does not exist - aborting"
          exit 1
        fi
      done <<< "$(cd ${PKG_FW_SOURCE} && eval "find "${fwline}"")"
    done < "${fwlist}"
  done

  PKG_KERNEL_CFG_FILE=$(kernel_config_path) || die

  # The following files are RPi specific and installed by brcmfmac_sdio-firmware-rpi instead.
  # They are also not required at all if the kernel is not suitably configured.
  if listcontains "${FIRMWARE}" "brcmfmac_sdio-firmware-rpi" || \
     ! grep -q "^CONFIG_BRCMFMAC_SDIO=y" ${PKG_KERNEL_CFG_FILE}; then
    rm -fr ${FW_TARGET_DIR}/brcm/brcmfmac43430*-sdio.*
    rm -fr ${FW_TARGET_DIR}/brcm/brcmfmac43455*-sdio.*
  fi

  # brcm pcie firmware is only needed by x86_64
  [ "${TARGET_ARCH}" != "x86_64" ] && rm -fr ${FW_TARGET_DIR}/brcm/*-pcie.*
  # add nvidia firmware for nouveau
  if listcontains "${GRAPHIC_DRIVERS}" "nouveau"; then
    cp -Lrv ${PKG_FW_SOURCE}/nvidia ${FW_TARGET_DIR}/
    rm -rv ${FW_TARGET_DIR}/nvidia/tegra*
  fi

  # On Lakka use iwlwifi firmware from this package instead of separate LibreELEC package
  if [ "${DISTRO}" = "Lakka" -a "${PROJECT}" = "Generic" ]; then
    cp -Lv ${PKG_FW_SOURCE}/iwlwifi-* ${FW_TARGET_DIR}/
  fi

  if [ "${PROJECT}" = "Ayn" -a "${DEVICE}" = "Odin" ]; then
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/sdm845
    cp "${PKG_BUILD}"/qcom/a630_sqe.fw "${INSTALL}"/usr/lib/firmware/qcom/
    cp "${PKG_BUILD}"/qcom/a630_gmu.bin "${INSTALL}"/usr/lib/firmware/qcom/
    cp "${PKG_BUILD}"/qcom/sdm845/adsp.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/cdsp.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/a630_zap.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/mba.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    #cp "${PKG_BUILD}"/qcom/sdm845/modem.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    #cp "${PKG_BUILD}"/qcom/sdm845/wlanmdsp.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/adspr.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/modemuw.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/cdspr.jsn  "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/adspua.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/modem_nm.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin
    #cp "${PKG_BUILD}"/qcom/sdm845/AYN/Odin/slpi.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin/
    #cp "${PKG_BUILD}"/qcom/sdm845/AYN/Odin/slpir.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin/
    #cp "${PKG_BUILD}"/qcom/sdm845/AYN/Odin/slpius.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin/
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/venus-5.2
    #cp "${PKG_BUILD}"/qcom/venus-5.2/venus.mbn "${INSTALL}"/usr/lib/firmware/qcom/venus-5.2/
    #cp "${PKG_BUILD}"/qcom/venus-5.2/venus.mdt "${INSTALL}"/usr/lib/firmware/qcom/venus-5.2/
    cp -r "${PKG_BUILD}"/ath10k "${INSTALL}"/usr/lib/firmware/
    cp -r "${PKG_BUILD}"/ath11k  "${INSTALL}"/usr/lib/firmware/
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/vpu
    cp "${PKG_BUILD}"/qcom/vpu/vpu20_p4.mbn "${INSTALL}"/usr/lib/firmware/qcom/vpu/
    mkdir -p "${INSTALL}"/usr/lib/firmware/qca
    cp "${PKG_BUILD}"/qca/htbtfw20.tlv "${INSTALL}"/usr/lib/firmware/qca/
    cp "${PKG_BUILD}"/qca/htnv20.bin "${INSTALL}"/usr/lib/firmware/qca/
    mkdir -p "${INSTALL}"/usr/lib/firmware/rtl_nic
    cp "${PKG_BUILD}"/rtl_nic/rtl8153a-4.fw "${INSTALL}"/usr/lib/firmware/rtl_nic/
  fi
  # Cleanup - which may be project or device specific
  find_file_path scripts/cleanup.sh && ${FOUND_PATH} ${FW_TARGET_DIR} || true
}

makeinstall_init() {
  if [ ! -d "${INSTALL}" ]; then
    mkdir -p ${INSTALL}
  fi
  #Install iniramfs
  if [ "${PROJECT}" = "Ayn" -a "${DEVICE}" = "Odin" ]; then
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/sdm845
    cp "${PKG_BUILD}"/qcom/a630_sqe.fw "${INSTALL}"/usr/lib/firmware/qcom/
    cp "${PKG_BUILD}"/qcom/a630_gmu.bin "${INSTALL}"/usr/lib/firmware/qcom/
    cp "${PKG_BUILD}"/qcom/sdm845/adsp.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/cdsp.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/a630_zap.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/mba.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    #cp "${PKG_BUILD}"/qcom/sdm845/modem.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    #cp "${PKG_BUILD}"/qcom/sdm845/wlanmdsp.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/adspr.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/modemuw.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/cdspr.jsn  "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/adspua.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/
    cp "${PKG_BUILD}"/qcom/sdm845/modem_nm.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin
    #cp "${PKG_BUILD}"/qcom/sdm845/AYN/Odin/slpi.mbn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin/
    #cp "${PKG_BUILD}"/qcom/sdm845/AYN/Odin/slpir.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin/
    #cp "${PKG_BUILD}"/qcom/sdm845/AYN/Odin/slpius.jsn "${INSTALL}"/usr/lib/firmware/qcom/sdm845/AYN/Odin/
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/venus-5.2
    #cp "${PKG_BUILD}"/qcom/venus-5.2/venus.mbn "${INSTALL}"/usr/lib/firmware/qcom/venus-5.2/
    #cp "${PKG_BUILD}"/qcom/venus-5.2/venus.mdt "${INSTALL}"/usr/lib/firmware/qcom/venus-5.2/
    mkdir -p "${INSTALL}"/usr/lib/firmware/ath11k/QCA6390/hw2.0
    cp "${PKG_BUILD}"/ath11k/QCA6390/hw2.0/board-2.bin "${INSTALL}"/usr/lib/firmware/ath11k/QCA6390/hw2.0/
    cp "${PKG_BUILD}"/ath11k/QCA6390/hw2.0/amss.bin "${INSTALL}"/usr/lib/firmware/ath11k/QCA6390/hw2.0/
    cp "${PKG_BUILD}"/ath11k/QCA6390/hw2.0/m3.bin "${INSTALL}"/usr/lib/firmware/ath11k/QCA6390/hw2.0/
    mkdir -p "${INSTALL}"/usr/lib/firmware/qcom/vpu
    cp "${PKG_BUILD}"/qcom/vpu/vpu20_p4.mbn "${INSTALL}"/usr/lib/firmware/qcom/vpu/
    mkdir -p "${INSTALL}"/usr/lib/firmware/qca
    cp "${PKG_BUILD}"/qca/htbtfw20.tlv "${INSTALL}"/usr/lib/firmware/qca/
    cp "${PKG_BUILD}"/qca/htnv20.bin "${INSTALL}"/usr/lib/firmware/qca/
    mkdir -p "${INSTALL}"/usr/lib/firmware/rtl_nic
    cp "${PKG_BUILD}"/rtl_nic/rtl8153a-4.fw "${INSTALL}"/usr/lib/firmware/rtl_nic/
  fi
}
