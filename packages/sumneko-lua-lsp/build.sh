TERMUX_PKG_HOMEPAGE=http://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Lsp server for lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@shadmansaleh"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SRCURL=https://github.com/sumneko/lua-language-server.git
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_BUILD_DEPENDS="ninja"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR
  cd $TERMUX_PKG_HOSTBUILD_DIR
  sudo apt update -y
  sudo apt install ninja-build -y
  git clone --depth 1 https://github.com/actboy168/luamake
  cd luamake
  git submodule update --init --recommend-shallow
  ./compile/install.sh
}

termux_step_make() {
  cd $TERMUX_PKG_SRCDIR
  $TERMUX_PKG_HOSTBUILD_DIR/luamake/luamake rebuild
  rm -rf ./3rd/luamake
  rm -rf ./.git/
	rm -rf $TERMUX_PKG_HOSTBUILD_DIR
  tar -zcf ../sumneko-lua-lsp.tar.gz .
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/../sumneko-lua-lsp.tar.gz "$TERMUX_PREFIX"/share/sumneko-lua-lsp/sumneko-lua-lsp.tar.gz
}
