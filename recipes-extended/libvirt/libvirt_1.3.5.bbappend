pkg_postinst_libvirt_prepend() {
        readlink -f /sbin/init | grep systemd && exit 0
}

USERADD_PARAM_${PN} += "${@bb.utils.contains('PACKAGECONFIG', 'polkit', '--system --no-create-home --user-group --home-dir ${sysconfdir}/polkit-1 polkitd;', '', d)}"
