TERMUX_PKG_HOMEPAGE=https://github.com/actboy168/luamake
TERMUX_PKG_DESCRIPTION="Build tool in lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@shadmansaleh"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/actboy168/luamake.git
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_BUILD_IN_SRC=true


termux_step_make() {
  termux_setup_ninja
  cd $TERMUX_PKG_SRCDIR
  ./compile/install.sh
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/luamake "$TERMUX_PREFIX"/bin/luamake
}
