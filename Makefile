emacs ?= emacs
wget ?= wget
batch = $(emacs) -batch \
	--eval "(let ((default-directory (expand-file-name \".emacs.d/elpa\" \"~\"))) \
		   (normal-top-level-add-subdirs-to-load-path))"

auto ?= company-cmd-autoloads.el

el = $(filter-out $(auto),$(wildcard *.el))
elc = $(el:.el=.elc)

auto_flags= \
	--eval "(let ((generated-autoload-file \
                      (expand-file-name (unmsys--file-name \"$@\"))) \
                      (wd (expand-file-name default-directory)) \
                      (backup-inhibited t) \
                      (default-directory (expand-file-name \".emacs.d/elpa\" \"~\"))) \
                   (normal-top-level-add-subdirs-to-load-path) \
                   (update-directory-autoloads wd))"

.PHONY: $(auto) clean
all: compile $(auto) README.md

compile : $(elc)
%.elc : %.el
	$(batch) -f batch-byte-compile $<

$(auto):
	$(emacs) -batch $(auto_flags)

README.md: el2markdown.el $(el)
	$(emacs) -batch -l $< $(el) -f el2markdown-write-readme
	$(RM) $@~

.INTERMEDIATE: el2markdown.el
el2markdown.el:
	$(wget) -q -O $@ "https://github.com/Lindydancer/el2markdown/raw/master/el2markdown.el"

TAGS: $(EL)
	$(RM) $@
	touch $@
	ls $(EL) | xargs etags -a -o $@

clean:
	$(RM) *~

distclean: clean
	$(RM) *.elc *autoloads.el *loaddefs.el TAGS
