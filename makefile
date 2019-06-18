.PHONY: help

# self-documented makefile, thanks to the Marmelab team
# see http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dot-bashrc: ## Setup dotfile for bashrc
	@stow bashrc

dot-git: ## Setup dotfile for git
	@stow git

dot-prompt: ## Setup dotfile for prompt
	@stow prompt

dot-vagrant: ## Setup dotfile for vagrant
	@stow vagrant
