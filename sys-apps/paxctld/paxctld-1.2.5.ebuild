# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit systemd

DESCRIPTION="PaX flags maintenance daemon"
HOMEPAGE="https://www.grsecurity.net/"
SRC_URI="https://www.grsecurity.net/${PN}/${PN}_${PV}.orig.tar.gz
	https://dev.gentoo.org/~blueness/hardened-sources/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
	# Respect Gentoo flags and don't strip
	sed -i \
		-e '/^CC/d' \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		-e '/STRIP/d' \
		Makefile || die

	eapply_user
}

src_install() {
	default

	systemd_dounit "${S}"/rpm/${PN}.service
}
