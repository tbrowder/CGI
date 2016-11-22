# generate the CGI.pm6 class module

EXE = ./test-cgi-utils.p6

DESTDIR = ../lib

DEBUG =
#DEBUG = debug

all: CGI

CGI:
	$(EXE) filter $(DEBUG) odir=$(DESTDIR)
