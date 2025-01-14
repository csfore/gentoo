# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A PHP implementation of the SMTP protocol"
HOMEPAGE="https://pear.php.net/package/Net_SMTP"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD-2"
SLOT="0"

KEYWORDS="amd64 arm ~hppa ppc64 ~s390 sparc x86"
IUSE="examples sasl test"
RDEPEND="dev-lang/php:*
	dev-php/PEAR-Net_Socket
	dev-php/PEAR-PEAR
	sasl? ( dev-php/PEAR-Auth_SASL )"
BDEPEND="test? ( ${RDEPEND} )"
RESTRICT="!test? ( test )"

src_install() {
	use examples && HTML_DOCS=( examples )
	php-pear-r2_src_install
}

src_test() {
	pear run-tests tests || die
}
