# CGI [![Build Status](https://travis-ci.org/tbrowder/CGI-Perl6.svg?branch=master)](https://travis-ci.org/tbrowder/CGI-Perl6)

# Class methods for the CGI environment.

Based on Perl 5's CGI module.

## Methods

See the methods and descriptions in file [lib/CGI.pm6](./lib/CGI.pm6).

## Tests

The tests use two of the author's Apache servers to provide CGI
responses and hence the standard environment variables. As long as
they are operative, they should permit good, active testing.

If they provide no response, or fail to work as expected, please
contact the author by email at <tom.browder@gmail.com> and put the
word '[CGI]' in the subject line.

The 'cgi-server' directory has instructions for setting up one's own
CGI test server.
