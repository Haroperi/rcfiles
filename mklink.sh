#!/bin/sh
perl -e 'foreach (qw(.vimrc .zshrc .aliases .screenrc .hgrc)) {`ln -vn $_ ~`;}'
mkdir -p ~/vim/undo

