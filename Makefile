DIR := ~

FILES := 
TARGETS := .tmux.conf
TEMPS := .tmux.conf.copy

.PHONY: all clean install uninstall FORCE

all: $(TARGETS)

copy_cmd := copy-selection
ifeq ($(shell uname -o),Cygwin)
	copy_cmd := copy-pipe tee /dev/clipboard
endif
ifneq ($(shell which xclip 2>/dev/null),)
	copy_cmd := copy-pipe xclip
endif

.tmux.conf: .tmux.conf.misc .tmux.conf.copy .tmux.conf.mouse
	cat $+ > $@

.tmux.conf.copy: Makefile
	echo "bind-key -T copy-mode-vi v send -X begin-selection" > $@
	echo "bind-key -T copy-mode-vi y send -X $(copy_cmd)" >> $@
	echo "unbind -T copy-mode-vi Enter" >> $@
	echo "bind-key -T copy-mode-vi Enter send -X $(copy_cmd)" >> $@
	which reattach-to-user-namespace > /dev/null 2>&1 \
		&& echo "set-option -g default-command 'reattach-to-user-namespace -l bash'" >> $@ \
		|| :

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
