# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_P="${PN}-${PV%.*}-${PV/*.}"

DESCRIPTION="IPA dictionary for MeCab"
HOMEPAGE="http://taku910.github.io/mecab/"
SRC_URI="mirror://sourceforge/${PN%-*}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ipadic"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="unicode"

RDEPEND="app-text/mecab[unicode=]"

DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_with unicode charset UTF-8)
}
