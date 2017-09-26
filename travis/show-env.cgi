#!/usr/bin/perl6

use CGI;

print "text/plain\n\n";

say "Environment variables:\n";
for %*ENV.kv -> $k, $v {
    say "$k: $v";
}
 
