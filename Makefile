LUA ?= lua
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
FENNEL ?= ./bin/fennel
FNLPATHS = src lib
FNLSOURCES = $(wildcard src/*.fnl)
FNLARGS = $(foreach path, $(FNLPATHS), --add-fennel-path $(path)/?.fnl)
FNLARGS += --no-metadata --require-as-include --compile

.PHONY: build clean test

build: fennel-lsp

fennel-lsp: $(FNLSOURCES)
	echo '#!/usr/bin/env $(LUA)' > $@
	$(FENNEL) $(FNLARGS) src/main.fnl >> $@
	chmod 755 $@

test:
	echo '#!/usr/bin/env $(LUA)' > tests/$@
	$(FENNEL) $(FNLARGS) tests/lexer.fnl >> tests/$@
	chmod 755 tests/$@
	./tests/test

clean:
	rm -f fennel-lsp $(wildcard src/*.lua)
	rm tests/test
