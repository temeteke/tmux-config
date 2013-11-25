#!/bin/sh

cd `dirname $0`

version=`tmux -V | awk '{print $2}'`

if [ -f ~/.tmux.conf ]; then
	rm ~/.tmux.conf
fi

if [ -f ~/.tmux.conf.local ]; then
	cat ~/.tmux.conf.local >> ~/.tmux.conf
fi

if [ -f ../private/tmux.conf ]; then
	cat ../private/tmux.conf >> ~/.tmux.conf
fi

if [ -f tmux.conf ]; then
	cat tmux.conf >> ~/.tmux.conf
fi

if [ `echo "$version >= 1.8" | bc` -eq 1 ] && which xclip > /dev/null 2>&1; then
	cat >> ~/.tmux.conf <<-_EOT_

		bind-key -t vi-copy v begin-selection
		bind-key -t vi-copy y copy-pipe "xclip"

		unbind -t vi-copy Enter
		bind-key -t vi-copy Enter copy-pipe "xclip"
	_EOT_
fi

tmux source-file ~/.tmux.conf
