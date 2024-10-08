# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_DOTNET="net35 net40 net45"
inherit autotools dotnet systemd

DESCRIPTION="XSP is a small web server that can host ASP.NET pages"
HOMEPAGE="https://www.mono-project.com/ASP.NET/"
SRC_URI="https://github.com/mono/xsp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="dev-db/sqlite:3"
RDEPEND="
	${DEPEND}
	acct-group/aspnet
	acct-user/aspnet
"

PATCHES=(
	"${FILESDIR}/aclocal-fix.patch"
)

METAFILETOBUILD=xsp.sln

src_prepare() {
	default

	eaclocal -I build/m4/shamrock -I build/m4/shave ${ACLOCAL_FLAGS}
	if test -z "${NO_LIBTOOLIZE}" ; then
		_elibtoolize --force --copy
	fi

	eautoconf
	eautomake --gnu --add-missing --force --copy
}

src_configure() {
	local myeconfargs=(
		--enable-maintainer-mode
		$(use_with test unit-tests)
		$(use_enable doc docs)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	local PATCHDIR="${FILESDIR}/2.2/"

	newinitd "${PATCHDIR}"/xsp.initd xsp
	newinitd "${PATCHDIR}"/mod-mono-server-r1.initd mod-mono-server
	newconfd "${PATCHDIR}"/xsp.confd xsp
	newconfd "${PATCHDIR}"/mod-mono-server.confd mod-mono-server

	insinto /etc/xsp4
	doins "${FILESDIR}"/systemd/mono.webapp
	insinto /etc/xsp4/conf.d

	# mono-xsp4.service was original name from
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770458;filename=mono-xsp4.service;att=1;msg=5
	# I think that using the same commands as in debian
	#     systemctl start mono-xsp4.service
	#     systemctl start mono-xsp4
	# is better than to have shorter command
	#     systemctl start xsp
	#
	# insinto /usr/lib/systemd/system
	systemd_dounit "${FILESDIR}"/systemd/mono-xsp4.service
}
