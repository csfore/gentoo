# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JRED
DIST_VERSION=1.10
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Event based transparent Client/Server RPC framework"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

# Note: Storable not listed in final alternation like it is
# upstream as storable alone is inherently insecure, so we force
# availability of at least one secure option
RDEPEND="
	|| (
		dev-perl/Event
		dev-perl/glib-perl
		dev-perl/AnyEvent
	)
	dev-perl/IO-Socket-SSL
	dev-perl/Net-SSLeay
	|| (
		>=dev-perl/Sereal-3.0.0
		dev-perl/CBOR-XS
		>=dev-perl/JSON-XS-3.0.0
	)
"
BDEPEND="${RDEPEND}"

# Before disabling test here again, please file a bug and help kentnl
# track it down, so we can at least run some tests where its sensible.
#DIST_TEST=skip
