DIR := ~

FILES := 
TARGETS := .tmux.conf
TEMPS := .tmux.conf.copy .tmux.conf.mouse .tmux.conf.utf8

.PHONY: all clean install uninstall FORCE

all: $(TARGETS)

copy := ''
ifeq ($(shell uname -o),Cygwin)
	copy := 'tee /dev/clipboard'
endif
ifneq ($(shell which xclip 2>/dev/null),)
	copy := 'xclip'
endif

.tmux.conf: .tmux.conf.misc .tmux.conf.copy .tmux.conf.mouse .tmux.conf.utf8
	cat $+ > $@

.tmux.conf.copy:
	echo "bind-key -t vi-copy v begin-selection" >> $@
	[ $$(tmux -V | awk '{print $$2}' | sed 's/[^0-9]//g') -ge 18 ] \
		&& echo "bind-key -t vi-copy y copy-pipe $(copy)" >> $@ \
		|| :
	echo "unbind -t vi-copy Enter" >> $@
	[ $$(tmux -V | awk '{print $$2}' | sed 's/[^0-9]//g') -ge 18 ] \
		&& echo "bind-key -t vi-copy Enter copy-pipe $(copy)" >> $@ \
		|| :
	which reattach-to-user-namespace > /dev/null 2>&1 \
		&& echo "set-option -g default-command 'reattach-to-user-namespace -l bash'" >> $@ \
		|| :

.tmux.conf.mouse: $(wildcard .tmux.conf.mouse.*)
	[ $$(tmux -V | awk '{print $$2}' | sed 's/[^0-9]//g') -ge 21 ] \
		&& cp .tmux.conf.mouse.21 $@ \
		|| cp .tmux.conf.mouse.20 $@

.tmux.conf.utf8: $(wildcard .tmux.conf.utf8.*)
	[ $$(tmux -V | awk '{print $$2}' | sed 's/[^0-9]//g') -ge 22 ] \
		&& cp .tmux.conf.utf8.22 $@ \
		|| cp .tmux.conf.utf8.21 $@

clean:
	rm -rf $(TARGETS) $(TEMPS)

$(DIR):
	mkdir -p $@

install: $(TARGETS) $(DIR)
	cp $(FILES) $(TARGETS) $(DIR)/
	[ -n "$$TMUX" ] && tmux source-file ~/.tmux.conf || echo "You are not in a tmux session."
		
uninstall:
	rm -rf $(addprefix $(DIR)/, $(FILES) $(TARGETS))

FORCE:
