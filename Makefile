# -*- mode: makefile-gmake -*-

EMACS = ~/Applications/Emacs.app/Contents/MacOS/Emacs
EMACS_BATCH = $(EMACS) -Q --batch

.DEFAULT: byte-compile

.PHONY: byte-compile
byte-compile: init.elc early-init.elc

.PRECIOUS: init.el early-init.el

%.elc: %.el
	@echo Compiling file $<
	@rm -f $@
	@$(EMACS_BATCH) -f batch-byte-compile $<
	@chmod ugo-w $@

%.el: %.org
	@echo Generating $@ from $<
	@$(EMACS_BATCH) --eval "(progn (require 'ob-tangle) (org-babel-tangle-file \"$<\" \"$@\" \"emacs-lisp\"))"
	@chmod ugo-w $@

.PHONY: link
link:
	@test -e ~/.emacs.d || \
	ln -s $(dir $(abspath $(lastword $(MAKEFILE_LIST)))) ~/.emacs.d

.PHONY: clean
clean:
	@rm -f init.el{,c} early-init.el{,c}
	@rm -f *~
