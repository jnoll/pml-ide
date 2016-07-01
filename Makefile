## $Id$
## jhnoll@gmail.com
DIR_MODE = ug+rwX,o+rX
SCRIPT_MODE = ug+rwx,o+rX
FILE_MODE = ug+rw,o+r
STACK.dir=$(shell stack path|awk '$$1 == "local-install-root:" {print $$2}')
STACK.old=.stack-work/install/x86_64-linux/lts-6.4/7.10.3
public_html = $(HOME)/public_html
dir = $(public_html)/pml-ide
pages = $(wildcard *.html)
scripts = $(wildcard *.hs)
#cgi=$(STACK.dir)/pmlcheck.cgi
cgi=$(patsubst %.hs,$(STACK.dir)/bin/%.cgi,$(scripts))


all: install

build: 
	stack build

what:
	@echo "scripts: $(scripts)"
	@echo "cgi: $(cgi)"
	@echo "STACK.old: $(STACK.old)"

install: build
	install -m $(DIR_MODE) -d $(dir)
	install -m $(FILE_MODE) $(pages) $(dir)
	install -m $(DIR_MODE) -d $(dir)/cgi-bin
	install -m $(SCRIPT_MODE) $(cgi) $(dir)/cgi-bin


%.cgi: %.hs
	cabal exec ghc -- --make ${LDFLAGS} $< -o $@


clean:
	rm -f *.hi *.o ${EXEC}
