# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="brise"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Data resources for Rime Input Method Engine"
HOMEPAGE="https://rime.im/ https://github.com/rime/brise"
SRC_URI="https://github.com/rime/${MY_PN}/releases/download/${MY_P%.*}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-3 LGPL-3 extra? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ppc64 ~riscv x86"
IUSE="extra"

DEPEND="app-i18n/librime"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "/^[[:space:]]*PREFIX/s:/usr:${EPREFIX}/usr:" Makefile || die

	default
}

src_compile() {
	emake $(usex extra all preset)
}
