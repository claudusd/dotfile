.PHONY: help

# self-documented makefile, thanks to the Marmelab team
# see http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dot-bashrc: ## Setup dotfile for bashrc
	@stow -d stow/ -t ~/ bashrc

dot-git: ## Setup dotfile for git
	@stow -d stow/ -t ~/ git

dot-prompt: ## Setup dotfile for prompt
	@stow -d stow/ -t ~/ prompt

dot-hashicorp: ## Setup dotfile for hashicorp
	@stow -d stow/ -t ~/ hashicorp

check-package: ## Check package installed
	@bin/check_package/main.bash

ssh-personal: ## Setup dotfile for personal's ssh
	@stow -d stow/ssh/ -t ~/.ssh/ global
	@stow -d stow/ssh/ -t ~/.ssh/ personal

dot-vim: ## Setup dotfile for vim
	@stow -d stow/ -t ~/ vim

dot-rust: ## Setup dotfile for rust
	@stow -d stow/ -t ~/ rust

dot-openvswitch: ## Setup dotile for openvwitch
	@stow -d stow/ -t ~/ openvswitch

dot-rvm: ## Setup dotile for rvm
	@stow -d stow/ -t ~ rvm
