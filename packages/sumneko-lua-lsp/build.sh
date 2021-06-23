TERMUX_PKG_HOMEPAGE=http://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Lsp server for lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@shadmansaleh"
TERMUX_PKG_VERSION="master"
TERMUX_PKG_SRCURL=https://github.com/sumneko/lua-language-server.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_DEPENDS="ninja"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
  sudo apt update -y
  sudo apt install ninja-build -y
  git submodule update --recommend-shallow --init --recursive
  cd 3rd/luamake
  ./compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
  tar -zcf ../sumneko-lua-lsp.tar.gz .
  mv ../sumneko-lua-lsp.tar.gz .
}

termux_step_make_install() {
	install -Dm600 sumneko-lua-lsp.tar.gz "$TERMUX_PREFIX"/share/sumneko-lua-lsp/sumneko-lua-lsp.tar.gz
}
