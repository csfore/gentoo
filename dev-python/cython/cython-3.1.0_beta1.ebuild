# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..12} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3 pypy3_11 python3_13{,t} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 multiprocessing pypi toolchain-funcs

DESCRIPTION="A Python to C compiler"
HOMEPAGE="
	https://cython.org/
	https://github.com/cython/cython/
	https://pypi.org/project/Cython/
"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.29.22-spawn-multiprocessing.patch"
	"${FILESDIR}/${PN}-0.29.23-pythran-parallel-install.patch"
)

distutils_enable_sphinx docs \
	dev-python/jinja2 \
	dev-python/sphinx-issues \
	dev-python/sphinx-tabs

python_compile() {
	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	distutils-r1_python_compile
}

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	# Needed to avoid confusing cache tests
	unset CYTHON_FORCE_REGEN

	tc-export CC
	# https://github.com/cython/cython/issues/1911
	local -x CFLAGS="${CFLAGS} -fno-strict-overflow"
	"${PYTHON}" runtests.py \
		-vv \
		-j "$(makeopts_jobs)" \
		--work-dir "${BUILD_DIR}"/tests \
		--no-examples \
		--no-code-style \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.rst ToDo.txt USAGE.txt )
	distutils-r1_python_install_all
}
