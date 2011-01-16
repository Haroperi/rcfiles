#!/bin/sh
perl -e 'foreach (qw(.vimrc .zshrc .aliases .screenrc)) {`ln -vn $_ ~`;}'
mkdir -p ~/.vim/undo

