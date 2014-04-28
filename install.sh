#!/bin/sh

cd `dirname $0`

version1=`tmux -V | awk '{print $2}' | cut -d. -f1`
version2=`tmux -V | awk '{print $2}' | cut -d. -f2 | cut -c1`

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

case `uname` in
	CYGWIN* )
		copy='tee /dev/clipboard'
		;;
	* )
		if which xclip > /dev/null 2>&1; then
			copy='xclip'
		else
			copy=''
		fi
		;;
esac

if [ $version1 -ge 1 ] && [ $version2 -ge 8 ]; then
	cat >> ~/.tmux.conf <<-_EOT_
		bind-key -t vi-copy v begin-selection
		bind-key -t vi-copy y copy-pipe "$copy"
	
		unbind -t vi-copy Enter
		bind-key -t vi-copy Enter copy-pipe "$copy"
	_EOT_
fi

if which reattach-to-user-namespace  > /dev/null 2>&1; then
	cat >> ./tmux.conf <<-_EOT_
		set-option -g default-command "reattach-to-user-namespace -l bash"
	_EOT_
fi

tmux source-file ~/.tmux.conf
