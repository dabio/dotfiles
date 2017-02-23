#!/usr/bin/env bash

.PHONY: all bin dotfiles

all: bin dotfiles

bin:
	# add aliases for things in bin
	for f in $(wildcard bin/*); do \
		f=$$(basename $$f); \
		ln -sf $(CURDIR)/bin/$$f /usr/local/bin/$$f; \
	done

dotfiles:
	# add aliases for dotfiles
	for f in $(filter-out .git .gitignore . .., $(wildcard .*)); do \
		f=$$(basename $$f); \
		ln -snf $(CURDIR)/$$f $(HOME)/$$f; \
	done
