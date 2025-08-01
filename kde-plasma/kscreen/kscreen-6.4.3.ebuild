# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.14.0
QTMIN=6.8.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="KDE Plasma screen management"
HOMEPAGE="https://invent.kde.org/plasma/kscreen"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="X"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtsensors-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-plasma/layer-shell-qt-${KDE_CATV}:6
	>=kde-plasma/libkscreen-${KDE_CATV}:6=
	>=kde-plasma/libplasma-${KDE_CATV}:6
	X? (
		>=dev-qt/qtbase-${QTMIN}:6[X]
		x11-libs/libX11
		x11-libs/libxcb:=
		x11-libs/libXi
	)
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=kde-plasma/kglobalacceld-${KDE_CATV}:6
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

CMAKE_SKIP_TESTS=(
	# last checked 2025-07-17, also fails upstream
	# FAIL!  : TestConfig::testDisabledScreenConfig() Compared values are not the same
	kscreen-kded-configtest
)

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
