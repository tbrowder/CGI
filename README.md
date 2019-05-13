# CGI [![Build Status](https://travis-ci.org/tbrowder/CGI-Perl6.svg?branch=master)](https://travis-ci.org/tbrowder/CGI-Perl6)

# Provides class methods for the CGI environment

Based on Perl 5's CGI module.

The current set of methods are merely easy short cuts
for obtaining CGI environment variables to satisfy
my current needs. I am happy
to add useful methods for users who submit an issue.

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

## LICENSE

This module is released under the same terms as Perl 6.

