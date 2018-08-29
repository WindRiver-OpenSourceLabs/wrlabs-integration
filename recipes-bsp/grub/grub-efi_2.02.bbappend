#
# Copyright (C) 2016-2017 Wind River Systems, Inc.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/grub-efi:"

SRC_URI += " \
    file://grub-runtime.cfg \
"

EFI_BOOT_PATH = "/boot/efi/EFI/BOOT"

do_compile_append_class-native() {
        make grub-editenv
}

do_install_append_class-native() {
    install -m 0755 grub-editenv "${D}${bindir}"
}

do_install_append_class-target() {
    install -d ${D}${EFI_BOOT_PATH}
    install -m 0600 "${WORKDIR}/grub-runtime.cfg" "${D}${EFI_BOOT_PATH}/grub.cfg"
    sed -i "s#%DISTRO_NAME%#${DISTRO_NAME}#g" "${D}${EFI_BOOT_PATH}/grub.cfg"
    sed -i "s#%DISTRO_VERSION%#${DISTRO_VERSION}#g" "${D}${EFI_BOOT_PATH}/grub.cfg"
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', '1', '0', d)}" = "0" ]; then
        sed -i '#^get_efivar#,#^fi#d' "${D}${EFI_BOOT_PATH}/grub.cfg"
    fi
}

do_deploy_append_class-target() {
    install -d ${DEPLOYDIR}

    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', '1', '0', d)}" = "1" ]; then 
        install -m 0600 "${D}${EFI_BOOT_PATH}/grub.cfg.p7b" "${DEPLOYDIR}"
    fi

    install -m 0600 "${D}${EFI_BOOT_PATH}/grub.cfg" "${DEPLOYDIR}"
   
    efi_target=`echo ${GRUB_IMAGE} | sed 's/^grub-efi-//'` 

    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', '1', '0', d)}" = "0" ]; then
        install -m 644 ${B}/${GRUB_IMAGE} ${D}${EFI_BOOT_PATH}/${efi_target}
    fi
}

FILES_${PN} += "${EFI_BOOT_PATH}"

addtask  deploy after do_install before do_package

python __anonymous() {
    d.setVarFlag('do_deploy', "fakeroot", "1")
}
