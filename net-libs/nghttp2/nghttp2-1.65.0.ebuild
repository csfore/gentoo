# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"
SRC_URI="https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/1.14" # 1.<SONAME>
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug hpack-tools jemalloc static-libs systemd test utils xml"

REQUIRED_USE="test? ( static-libs )"
RESTRICT="!test? ( test )"

SSL_DEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist(-),${MULTILIB_USEDEP}]
"
RDEPEND="
	hpack-tools? ( >=dev-libs/jansson-2.5:= )
	jemalloc? ( dev-libs/jemalloc:=[${MULTILIB_USEDEP}] )
	utils? (
		${SSL_DEPEND}
		>=dev-libs/libev-4.15[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-1.2.3[${MULTILIB_USEDEP}]
		net-dns/c-ares:=[${MULTILIB_USEDEP}]
	)
	systemd? ( >=sys-apps/systemd-209 )
	xml? ( >=dev-libs/libxml2-2.7.7:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	#TODO: enable HTTP3
	#requires quictls/openssl, libngtcp2, libngtcp2_crypto_quictls, libnghttp3
	local mycmakeargs=(
		-DENABLE_EXAMPLES=OFF
		-DENABLE_FAILMALLOC=OFF
		-DENABLE_HTTP3=OFF
		-DENABLE_WERROR=OFF
		-DENABLE_THREADS=ON
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_HPACK_TOOLS=$(multilib_native_usex hpack-tools)
		$(cmake_use_find_package hpack-tools Jansson)
		-DWITH_JEMALLOC=$(multilib_native_usex jemalloc)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TESTING=$(usex test)
		$(cmake_use_find_package systemd Systemd)
		-DENABLE_APP=$(multilib_native_usex utils)
		-DWITH_LIBXML2=$(multilib_native_usex xml)
	)
	cmake_src_configure
}

multilib_src_test() {
	eninja check
}
