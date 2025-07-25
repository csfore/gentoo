# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANBORN
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Query a Google SafeBrowsing table"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-perl/URI
	>=virtual/perl-Math-BigInt-1.87
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/pod.t" )
