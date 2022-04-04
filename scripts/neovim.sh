#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

NVM_DIR="${HOME}/.nvm"

do_configure() {
	info "[neovim] Configure"
	info "[neovim][configure] Set as default editor"
	local nvim_path
	nvim_path="$(type -P nvim)"
	sudo update-alternatives --install /usr/bin/vi vi "$nvim_path" 60
	sudo update-alternatives --set vi "$nvim_path"
	sudo update-alternatives --install /usr/bin/vim vim "$nvim_path" 60
	sudo update-alternatives --set vim "$nvim_path"
	sudo update-alternatives --install /usr/bin/editor editor "$nvim_path" 60
	sudo update-alternatives --set editor "$nvim_path"

	info "[neovim][configure] Create configuration directory symlink"
	rm -rf "${XDG_CONFIG_HOME}/nvim" && mkdir -p "${XDG_CONFIG_HOME}"
	ln -fs "$(pwd)/nvim" "${XDG_CONFIG_HOME}/nvim"

	info "[neovim][configure] Install the neovim package for languages"
	info "[neovim][configure][languages] Python"
	python3 -m pip install --quiet neovim neovim-remote --user
}

main() {
	command=$1
	case $command in
	"configure")
		shift
		do_configure "$@"
		;;
	*)
		error "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
