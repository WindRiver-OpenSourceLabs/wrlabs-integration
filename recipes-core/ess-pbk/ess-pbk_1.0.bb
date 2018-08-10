#
# Copyright (C) 2012-2013 Wind River Systems, Inc.
#

SUMMARY = " The ESS gpg public key used to be imported into the target "
DESCRIPTION = "\
     The ESS gpg public key used to be imported into the target "
SECTION = "devel"
LICENSE = "windriver"
LIC_FILES_CHKSUM = "file://${WORKDIR}/copyright;md5=c3beeab222a6bef8eaa456225c58325c"

PR = "r0"
SRC_URI = "\
    file://copyright \
    file://RPM-GPG-KEY-ESS \
"


do_compile[noexec] = "1"
do_patch[noexec] = "1"
do_configure[noexec] = "1"
S="${WORKDIR}"

PACKAGES = "${PN}"
FILES_${PN} = "/etc/*"

do_install () {
    local INSTALL_DIR="${D}/etc/"
    install -d  ${INSTALL_DIR}pki
    install -d  ${INSTALL_DIR}pki/rpm-gpg
    install -m 0755 ${WORKDIR}/RPM-GPG-KEY-ESS ${INSTALL_DIR}
}

pkg_postinst_${PN} () {
    [ -f /usr/bin/rpm ] && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-ESS 2>/dev/null
}

