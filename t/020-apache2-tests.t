#!/usr/bin/env perl6

use Test;

use Cro::HTTP::Client;
use CGI;
use CGI::Vars;


# tests here use a live apache2 server (on the local host
# and on travis)

plan 9;

my $debug = 0;

# reuse defaults
my $client = Cro::HTTP::Client.new(headers => [ User-agent => 'Cro' ]);
# HTTP
my $host = 'localhost'; # apache2
my $port = 80;
my $host-port = "$host:$port";

my ($resp, $body, %body, @body, $res, @res, %res, $url);

$url = 'cgi-bin/show-env.cgi';
lives-ok { $resp = await $client.get: "http://$host-port/$url" }, 'request environment list';
lives-ok { $body = await $resp.body-text; }, 'the required environment list';

my %env;
%*ENV = {};
for $body.lines -> $line is copy {
    next if $line !~~ /\S/;
    say "DEBUG: line = '$line'" if $debug;
    # each line should be two words: key : value
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
	die "FATAL:  No separator char ':'for line: '$line'";
    }
}

# ensure we have all MUST request CGI vars (not TLS yet)
my $no-vars = 0;
for %req-meta-vars.keys -> $k {
    if not %env{$k} {
	++$no-vars;
	warn "Std var '$k' is missing.";
    }
}
is $no-vars, 0, 'MUST have request vars';

# check the vars to see if any are NOT known?? not now

# check the CGI variables
my $c = CGI.new;
my @ekeys;
lives-ok { @ekeys = $c.http; }, 'c.http';
say @ekeys.gist if $debug;
my @expect = <HTTP_HOST HTTP_USER_AGENT>;
is-deeply @ekeys, @expect, 'http method';

lives-ok { $resp = $c.server-software; }, 'c.server-software';
like $resp, /Apache/, 'c.server-software matches';

lives-ok { $resp = $c.remote-addr; }, 'c.remote-addr';
like $resp, /\d*/, 'c.remote-addr matches';