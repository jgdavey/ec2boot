#!/usr/bin/env bash

source ~/.rvm/scripts/rvm

cd $HOME

echo 'colorscheme railscasts' >> $HOME/.vimrc.local
echo 'set cursorline' >> $HOME/.vimrc.local

# Dotmatrix
[ -d hashrocket ] || mkdir hashrocket
cd hashrocket

if [ ! -d dotmatrix ]; then
    git clone git://github.com/hashrocket/dotmatrix
    rm dotmatrix/.rvmrc # prevent the warning
fi

cd dotmatrix

cat <<'EOF' > FILES
.ctags
.cvsignore
.gitconfig
.hashrc
.irbrc
.pryrc
.rdebugrc
.screenrc
.tmux.conf
.vim
.vimrc
.zsh
.zshrc
EOF

bin/install

cd $HOME

# HR

cd hashrocket

if [ ! -d hr ]; then
    git clone git://github.com/hashrocket/hr
fi

cd hr
./bin/hr init

echo 'eval "$(/home/dev/hashrocket/hr/bin/hr init -)"' >> $HOME/.zshrc.local

cd $HOME

# Default Ruby
rvm install 1.9.3
rvm use --default 1.9.3

touch $HOME/.gemrc
echo "install: --no-ri --no-rdoc" >> $HOME/.gemrc
echo "update: --no-ri --no-rdoc" >> $HOME/.gemrc

# A bunch of vim plugins
~/hashrocket/dotmatrix/bin/vimbundles.sh
