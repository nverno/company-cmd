emacs ?= emacs
wget ?= wget

BATCH := $(emacs) -Q -batch
EL = $(filter-out %-autoloads.el, $(wildcard *.el))

.PHONY: clean distclean
all:

README.md: el2markdown.el $(EL)
	$(BATCH) -l $< $(EL) -f el2markdown-write-readme
	$(RM) $@~

.INTERMEDIATE: el2markdown.el
el2markdown.el:
	$(wget) \
  -q -O $@ "https://github.com/Lindydancer/el2markdown/raw/master/el2markdown.el"

clean:
	$(RM) *~

distclean: clean
	$(RM) *.elc *autoloads.el *loaddefs.el TAGS
