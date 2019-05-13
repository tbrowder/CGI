#!/usr/bin/env perl6

use Test;

use HTTP::UserAgent;

use CGI;
use CGI::Vars;

# tests here use a live apache2 server

#plan 9;

my $debug = 0;

# HTTP tests
my $protocol = 'http';
my $host = 'niceville.pm.org'; # apache2

# reuse defaults
my $client = HTTP::UserAgent.new;

my ($resp, $body, %body, @body, $res, @res, %res, $url);

$url = 'cgi-test/show-env.cgi';
{
    lives-ok { $resp = $client.get("$protocol://$host/$url"); }, 
        'request environment list';
}

my $test-env = 0;
{
    lives-ok {
	if $resp.is-success {
	    $body = $resp.content;
	    $test-env = 1;
	}
	else {
	    $body = $resp.status-line;
	}
    }, 'the required environment list';
}

my %env;
if $test-env {
    %*ENV = {};
    for $body.lines -> $line is copy {
	next if $line !~~ /\S/;
	say "DEBUG: line = '$line'" if $debug;
	# each line should be two words: key : value

	# skip some lines
	my $idx = index $line, ':';
	my ($k, $v);
	if $idx.defined {
	    $k = $line.substr: 0, $idx;
	    $v = $line.substr: $idx+1;
	    $k .= trim;
	    $v .= trim;
	    %env{$k} = $v;
	    %*ENV{$k} = $v;
	    say "DEBUG: k = '$k', v = '$v'" if $debug;
	}
	else {
	    say "WARNING: No separator char ':'for line: '$line'";
	}
    }
}

=begin comment
# ensure we have all MUST request CGI vars (not TLS yet)
my $no-vars = 0;
for %req-meta-vars.keys -> $k {
    if not %env{$k} {
	++$no-vars;
	warn "Std var '$k' is missing.";
    }
}
is $no-vars, 0, 'MUST have request vars';
=end comment


if $test-env {
    # check the vars to see if any are NOT known?? not now

    # check the CGI variables
    my $c = CGI.new;
    my @ekeys;
    lives-ok { @ekeys = $c.http; }, 'c.http';
    say @ekeys.gist if $debug;
    #my @expect = <HTTP_HOST HTTP_USER_AGENT>; # CRO
    my @expect = <HTTP_CONNECTION HTTP_HOST>; # UserAgent
    #is-deeply @ekeys, @expect, 'http method';
    my $str = join ',', @expect;
    like $str, /HTTP_/, 'http method';

    lives-ok { $resp = $c.server-software; }, 'c.server-software';
    like $resp, /Apache/, 'c.server-software matches';

    lives-ok { $resp = $c.remote-addr; }, 'c.remote-addr';
    like $resp, /\d*/, 'c.remote-addr matches';
}


done-testing;
