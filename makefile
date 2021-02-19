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

dot-vim: ## Setup dotfile for vim
	@stow -d stow/ -t ~/ vim

dot-openvswitch: ## Setup dotile for openvwitch
	@stow -d stow/ -t ~/ openvswitch

dot-home: ## Setup dotfile for home
	@stow -d stow/ -t ~ home

dot-ledger: ## Setup dotfile for ledger
	@stow -d stow -t ~ ledger

dot-haskell: ## Setup dotfile for haskell
	@stow -d stow/ -t ~ haskell

dot-openstack-cli: ## Setup dotfile for openstack-cli
	@stow -d stow/ -t ~ openstack-cli
