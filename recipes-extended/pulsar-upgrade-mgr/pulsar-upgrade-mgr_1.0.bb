SUMMARY = "pulsar upgrade config manager"
DESCRIPTION = "Example of how to run some postinstall and postrm \
operations to complete the pulsar upgrade"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

S = "${WORKDIR}"

SRC_URI = "file://COPYING \
           file://pulsar-upgrade-postinst.sh \
           file://pulsar-upgrade-postrm.sh \
           file://pulsar_upgrade_${TARGET_ARCH}.sh \
          "

FILES_${PN} += "/usr/bin/pulsar-upgrade-postinst.sh \
                /usr/bin/pulsar-upgrade-postrm.sh \
               "

do_install() {
	install -d ${D}/usr/bin
	install -m 0755 ${S}/pulsar-upgrade-postinst.sh ${D}/usr/bin
	install -m 0755 ${S}/pulsar-upgrade-postrm.sh ${D}/usr/bin
	if [ "${TARGET_ARCH}" = "x86_64" ]; then
		install -m 0755 ${S}/pulsar_upgrade_${TARGET_ARCH}.sh ${D}/usr/bin/pulsar_upgrade.sh
	fi
}

pkg_postinst_${PN} () {
	if [ -f /usr/bin/pulsar-upgrade-postinst.sh ]; then
		/usr/bin/pulsar-upgrade-postinst.sh
	fi
}

pkg_postrm_${PN} () {
	if [ -f /usr/bin/pulsar-upgrade-postrm.sh ]; then
		/usr/bin/pulsar-upgrade-postrm.sh
	fi
}
