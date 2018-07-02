DESCRIPTION = "Firmware for the TI WL18XX BT"
HOMEPAGE = "http://git.ti.com/ti-bt"
LICENSE = "Firmware-TI"
SECTION = "kernel"

LIC_FILES_CHKSUM = "\
    file://LICENSE;md5=f39eac9f4573be5b012e8313831e72a9 \
"

NO_GENERIC_LICENSE[Firmware-TI] = "LICENSE"

SRCREV = "9b430856dd3875081073422ecd2dd48d09a328c6"
PE = "1"
PV = "0.0+git${SRCPV}"

SRC_URI = "git://git.ti.com/ti-bt/service-packs.git"

S = "${WORKDIR}/git"

inherit allarch

CLEANBROKEN = "1"

do_compile() {
	:
}

do_install() {
	install -d  ${D}${nonarch_base_libdir}/firmware/ti-connectivity
	cp -r ./initscripts/* ${D}${nonarch_base_libdir}/firmware/ti-connectivity/
}

FILES_${PN} = " \
        ${nonarch_base_libdir}/firmware/ti-connectivity/* \
"
# Firmware files are generally not ran on the CPU, so they can be
# allarch despite being architecture specific
INSANE_SKIP = "arch"
