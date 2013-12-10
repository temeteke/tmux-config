#!/bin/sh

cd `dirname $0`

ver2num() {
	versionNumber=0
	for i in `seq 2`; do
		num=`echo $1 | cut -d '.' -f $i` 
		if [ -z $num ]; then 
			num=0
		fi
		versionNumber=`expr $versionNumber \* 1000 + $num`
	done
	echo $versionNumber
}

version=`tmux -V | awk '{print $2}'`
version=`ver2num $version`

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

if [ $version -ge `ver2num 1.8` ] && which xclip > /dev/null 2>&1; then
	cat >> ~/.tmux.conf <<-_EOT_

		bind-key -t vi-copy v begin-selection
		bind-key -t vi-copy y copy-pipe "xclip"

		unbind -t vi-copy Enter
		bind-key -t vi-copy Enter copy-pipe "xclip"
	_EOT_
fi

if which reattach-to-user-namespace  > /dev/null 2>&1; then
	cat >> ./tmux.conf <<-_EOT_
		set-option -g default-command "reattach-to-user-namespace -l bash"
	_EOT_
fi

tmux source-file ~/.tmux.conf
