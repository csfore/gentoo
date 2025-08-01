# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FGLOCK
DIST_VERSION=0.3900
inherit perl-module

DESCRIPTION="Datetime sets and set math"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-perl/DateTime-0.120.0
	>=dev-perl/Set-Infinite-0.590.0
	dev-perl/Params-Validate
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/DateTime-Event-Recurrence
	)
"
# meta.json is incorrect, it needs P-V and M-B
