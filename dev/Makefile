# generate the CGI.pm6 class module

PERL := perl6 -I../lib

EXE := ./test-cgi-utils.p6

DESTDIR = ../lib-dev

DEBUG =
#DEBUG = debug

all: CGI

CGI:
	$(PERL) $(EXE) filter $(DEBUG) odir=$(DESTDIR)

doc: docs

docs:
	$(EXE2)
