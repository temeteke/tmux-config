.PHONY: all clean install uninstall FORCE
all: .tmux.conf

copy := ''
ifeq ($(shell uname -o),Cygwin)
	copy := 'tee /dev/clipboard'
endif
ifeq ($(shell which xclip > /dev/null 2>&1; echo $?),0)
	copy := 'xclip'
endif

.tmux.conf:
	cp .tmux.conf.misc .tmux.conf
	echo >> .tmux.conf
	echo "bind-key -t vi-copy v begin-selection" >> .tmux.conf
	echo "bind-key -t vi-copy y copy-pipe $(copy)" >> .tmux.conf
	echo "unbind -t vi-copy Enter" >> .tmux.conf
	echo "bind-key -t vi-copy Enter copy-pipe $(copy)" >> .tmux.conf
	which reattach-to-user-namespace > /dev/null 2>&1 \
		&& echo "set-option -g default-command 'reattach-to-user-namespace -l bash'" >> .tmux.conf \
		|| true

clean:
	rm -rf .tmux.conf

install: all
	cp .tmux.conf ~/
	tmux source-file ~/.tmux.conf
		
uninstall:
	rm -rf ~/.tmux.conf

FORCE:
