#!/usr/bin/env bash

.PHONY: all bin dotfiles

all: bin dotfiles

bin:
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sf $$file /usr/local/bin/$$f; \
	done

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -maxdepth 1 -name ".*" -not -name ".dotfiles" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".travis.yml" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sf $$file $(HOME)/$$f; \
	done
