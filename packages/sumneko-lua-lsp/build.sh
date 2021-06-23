TERMUX_PKG_HOMEPAGE=http://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Lsp server for lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@shadmansaleh"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SRCURL=https://github.com/sumneko/lua-language-server.git
TERMUX_PKG_BUILD_DEPENDS="ninja"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/build
	cd $TERMUX_PKG_HOSTBUILD_DIR/build
  git clone --depth 1 https://github.com/sumneko/lua-language-server.git
  cd lua-language-server
  git 
  cd lua-language-server
  git submodule update --recommend-shallow --init --recursive
  cd 3rd/luamake
  ./compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
  tar -zcf $TERMUX_PKG_HOSTBUILD_DIR/build/sumneko-lua-lsp.tar.gz .
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/build/sumneko-lua-lsp.tar.gz "$TERMUX_PREFIX"/share/sumneko-lua-lsp/sumneko-lua-lsp.tar.gz
}
