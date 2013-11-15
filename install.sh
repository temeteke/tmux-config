#!/bin/sh

cd `dirname $0`

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

tmux source-file ~/.tmux.conf
