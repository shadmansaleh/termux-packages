TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@shadmansaleh"
TERMUX_PKG_VERSION=master
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libuv, luv, libandroid-support"
TERMUX_PKG_HOSTBUILD=true
# TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD_DIR=$TERMUX_PKG_SRCDIR

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_JEMALLOC=OFF
-DGETTEXT_MSGFMT_EXECUTABLE=$(which msgfmt)
-DGETTEXT_MSGMERGE_EXECUTABLE=$(which msgmerge)
-DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf
-DPKG_CONFIG_EXECUTABLE=$(which pkg-config)
-DXGETTEXT_PRG=$(which xgettext)
-USE_BUNDLED_LIBUV=OFF
-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR
-DUSE_BUNDLED_LUAROCKS=ON
-DTreeSitter_INCLUDE_DIR=$TERMUX_PKG_HOSTBUILD_DIR/usr/include
-DTreeSitter_LIBRARY=$TERMUX_PKG_HOSTBUILD_DIR/usr/lib/libtree-sitter.a
"
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_MATH_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libm.so"
}

termux_step_host_build() {
	termux_setup_cmake

	mkdir -p $TERMUX_PKG_SRCDIR/.deps
	cd $TERMUX_PKG_SRCDIR/.deps
	cmake $TERMUX_PKG_SRCDIR/third-party $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	CMAKE_EXTRA_FLAGS=$TERMUX_PKG_EXTRA_CONFIGURE_ARGS make -j1

	cd $TERMUX_PKG_SRCDIR
	CMAKE_EXTRA_FLAGS=$TERMUX_PKG_EXTRA_CONFIGURE_ARGS make install
	make distclean
	rm -Rf build/
}

termux_step_post_make_install() {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/sysinit.vim $_CONFIG_DIR/
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/nvim 40
			update-alternatives --install \
				$TERMUX_PREFIX/bin/vi vi $TERMUX_PREFIX/bin/nvim 15
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/nvim
			update-alternatives --remove vi $TERMUX_PREFIX/bin/nvim
		fi
	fi
	EOF
}
