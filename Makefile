.PHONY: all clean install uninstall FORCE
all: .tmux.conf

copy := ''
ifeq ($(shell uname -o),Cygwin)
	copy := 'tee /dev/clipboard'
endif
ifneq ($(shell which xclip),)
	copy := 'xclip'
endif

.tmux.conf: .tmux.conf.misc .tmux.conf.copy .tmux.conf.mouse
	cat $+ > $@

.tmux.conf.copy:
	echo "bind-key -t vi-copy v begin-selection" >> $@
	echo "bind-key -t vi-copy y copy-pipe $(copy)" >> $@
	echo "unbind -t vi-copy Enter" >> $@
	echo "bind-key -t vi-copy Enter copy-pipe $(copy)" >> $@
	which reattach-to-user-namespace > /dev/null 2>&1 \
		&& echo "set-option -g default-command 'reattach-to-user-namespace -l bash'" >> $@ \
		|| true

.tmux.conf.mouse:
	[ $$(tmux -V | awk '{print $$2}' | sed 's/[^0-9]//g') -ge 21 ] \
		&& cp .tmux.conf.mouse.21 $@ \
		|| cp .tmux.conf.mouse.20 $@

clean:
	rm -rf .tmux.conf

install: all
	cp .tmux.conf ~/
	[ -n "$$TMUX" ] && tmux source-file ~/.tmux.conf || echo "You are not in a tmux session."
		
uninstall:
	rm -rf ~/.tmux.conf

FORCE:
