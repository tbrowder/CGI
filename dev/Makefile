# generate the CGI.pm6 class module

EXE := ./test-cgi-utils.p6

EXE2 := create-md.p6

DESTDIR = ../lib

DEBUG =
#DEBUG = debug

all: CGI

CGI:
	$(EXE) filter $(DEBUG) odir=$(DESTDIR)

doc: docs

docs:
	$(EXE2)