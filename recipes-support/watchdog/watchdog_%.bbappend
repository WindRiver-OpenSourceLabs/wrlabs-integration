SRC_URI += "\
	file://clearbootflag_${TARGET_ARCH}.sh \
"
FILESEXTRAPATHS_prepend := "${THISDIR}:${THISDIR}/files:"

do_install_append() {
	install -d ${D}${sbindir}
	install -m 0755 ${WORKDIR}/clearbootflag_${TARGET_ARCH}.sh ${D}${sbindir}/clearbootflag.sh
	if [ -e "${D}${systemd_system_unitdir}/watchdog.service" ] ; then
		sed -i "/ExecStart=/a ExecStartPost=-/usr/sbin/clearbootflag.sh" ${D}${systemd_system_unitdir}/watchdog.service
	fi
}

FILES_${PN} += " \
	${sbindir}/clearbootflag.sh \
"
