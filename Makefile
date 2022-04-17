CCRED=\033[0;31m
CCEND=\033[0m

.PHONY: build clean help samples config

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

config: ## Print the site configuration (e.g., hugo)
	@hugo env
	@hugo config
	@echo "Create a list of draft pages"
	@hugo list drafts >draftItems.txt

clean: ## Delete outputs: public & resources
	rm -rf public resources 

build: module-check ## Build site with production settings and put deliverables in ./public
	hugo --verbose --minify

dev: clean serve ## Build site with development settings

module : ## Retrieve the latest commit in all the repositories listed as a submodule
	git submodule update --remote --recursive

open:
	open http://localhost:8080/	## Open the site in the current default browser

serve:
	hugo server --watch --verbose --disableFastRender --renderToDisk --printI18nWarnings --port 8080

status:
	@git submodule status --recursive | awk '/^[+-]/ {printf "\033[31mWARNING\033[0m Submodule not initialized: \033[34m%s\033[0m\n",$$2}' 1>&2
	@git status

check-links: link-checker-setup run-link-checker ## Check links

link-checker-setup:
	curl https://htmltest.wjdp.uk | bash

run-link-checker:
	@echo "$(CCRED)**** The use of link-checked is deprecated. Use container-image instead. ****$(CCEND)"
	bin/htmltest