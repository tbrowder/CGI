#!/usr/local/rakudo.d/bin/perl6

# This simple CGI program serves to
# cause the test server to provide
# the expected environment variables
# to the client browser.

print "Content-type: text/plain\n\n";

for %*ENV.kv -> $k, $v {
    say "$k : $v";
}
