#!/usr/bin/perl6

# for local testing:
use lib </usr/local/people/tbrowde/mydata/tbrowde-home-bzr/perl6/my-public-modules/github/staged-for-ecosystem/CGI-Perl6/lib>;

use CGI;

#my $c = CGI.new;

print "Content-type: text/plain\n\n";

#say $c.http;

#=begin comment
#say "Environment variables:\n";
for %*ENV.kv -> $k, $v {
    say "$k : $v";
}
#=end comment
