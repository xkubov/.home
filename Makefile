##
## Installation Makefile
##
## WARNING: This Makefile is only in its initail <<lame>> version.
##

PROJECT=$(PWD)
BASHDIR=$(PROJECT)/bash
TMUXDIR=$(PROJECT)/tmux
VIMDIR=$(PROJECT)/vim
GITDIR=$(PROJECT)/git

SAVE="$(HOME)/old_env_save"

all: core scripts

core: bashc vimc fzfc gitc sshc

vimc: will-save config
	$(eval O1=$(HOME)/.vimrc)
	$(eval O2=$(HOME)/.config/nvim)
	$(eval O3=$(HOME)/.vim)
	@test ! -e $(O1) || (cp -r $(O1) $(SAVE) && rm -rf $(O1))
	@test ! -L $(O1) || rm -rf $(O1)
	@test ! -e $(O2) || mv $(O2) $(SAVE)
	@test ! -L $(O2) || rm -rf $(O2)
	@test ! -e $(O3) || rm -rf $(O3)
	@test ! -L $(O3) || rm -rf $(O3)

	ln -s $(VIMDIR)/.vimrc $(O1)
	mkdir -p $(O2)
	ln -s $(VIMDIR)/.vimrc $(O2)/init.vim
	ln -s $(VIMDIR)/coc-settings.json $(O2)/coc-settings.json
	mkdir -p $(O3)
	@git clone https://github.com/VundleVim/Vundle.vim.git $(O3)/bundle/Vundle.vim
	vim +PluginInstall +qall

bashc: will-save
	$(eval O1=$(HOME)/.bashrc)
	$(eval O2=$(HOME)/.bash_profile)
	$(eval O3=$(HOME)/.bash_conf)
	$(eval O4=$(HOME)/.bashrc_local)
	@test ! -e $(O1) || (cp -r $(O1) $(SAVE) && rm -rf $(O1))
	@test ! -L $(O1) || rm -rf $(O1)
	@test ! -e $(O2) || (cp -r $(O2) $(SAVE) && rm -rf $(O2))
	@test ! -L $(O2) || rm -rf $(O2)
	@test ! -e $(O3) || (cp -r $(O3) $(SAVE) && rm -rf $(O3))
	@test ! -L $(O3) || rm -rf $(O3)
	@test ! -e $(O4) || (cp -r $(O4) $(SAVE) && rm -rf $(O4))
	@test ! -L $(O4) || rm -rf $(O4)

	ln -s $(BASHDIR)/.bashrc $(O1)
	ln -s $(BASHDIR)/.bashrc $(O2)
	ln -s $(BASHDIR)/.bash_conf $(O3)
	cp $(BASHDIR)/.bashrc_local $(HOME)/.bashrc_local

tmuxc:
	$(eval O1=$(HOME)/.tmux.conf)
	ln -s $(TMUXDIR)/.tmux.conf $(O1)

config:
	$(eval O5=$(HOME)/.config)
	@test ! -e $(O5) || rm -rf $(O5)
	@test ! -L $(O5) || rm -rf $(O5)
	@mkdir -p $(O5)

gitc:
	$(eval O1=$(HOME)/.gitconfig)
	@test ! -e $(O1) || rm -rf $(O1)
	@test ! -L $(O1) || rm -rf $(O1)
	ln -s $(GITDIR)/.gitconfig $(O1)

will-save:
	@test -f $(SAVE) && rm -rf $(SAVE) || true
	@test -d $(SAVE) || mkdir -p $(SAVE)

sshc:
	mkdir -p $(HOME)/.ssh
	rm -rf $(HOME)/.ssh/config
	ln -s $(PROJECT)/ssh/config $(HOME)/.ssh/config
