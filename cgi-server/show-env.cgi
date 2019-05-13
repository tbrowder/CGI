#!/usr/bin/perl6

use lib </myperl6/lib>;

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
