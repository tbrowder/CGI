#!/usr/bin/env perl6

use Test;

use HTTP::UserAgent;

use CGI;
use CGI::HttpVars;

# tests here use a live apache2 server

#plan 10;

my $debug = 0;

# HTTP tests
my $protocol  = 'http';
my $client = HTTP::UserAgent.new;
$client.timeout = 1;

# expected values
my $serv-name = 'niceville.pm.org'; # apache2
my $serv-addr = '142.54.186.2';
my $serv-soft = 'Apache/2.4.38 (Unix) OpenSSL/1.1.0j';
my $serv-port = '80';

my $http-conn = 'close';

# reuse defaults
my ($resp, $body, %body, @body, $res, @res, %res);

# this depends on one's server setup
my $url = 'cgi-bin-cmn/show-env.cgi';
my $host = $serv-name;
lives-ok { $resp = $client.get("$protocol://$host/$url"); },
    'request environment list';

ok $resp.is-success, 'successful query';

$body = $resp.content;

# create the remote server's environment for testing locally
my %env;
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
	say "DEBUG: k = '$k', v = '$v'" if $debug;
    }
    else {
	say "WARNING: No separator char ':'for line: '$line'" if $debug > 1;
    }
}

# ensure we have all expected vars
my $no-vars = 0;
for %vars.keys -> $k {
    if not %env{$k}:exists {
        ++$no-vars;
	warn "Std var '$k' is missing.";
    }
}
is $no-vars, 0, 'has expected HTTP vars';

# check the remote CGI variables with the CGI methods
my $c = CGI.new: :env(%env);

my @ekeys;
lives-ok { @ekeys = $c.http; }, 'c.http';

say @ekeys.gist if $debug;

like $c.server-software, /Apache/, 'c.server-software';
like $c.remote-addr, /\d*/, 'c.remote-addr';
is $c.server-name, $serv-name, 'c.server-name';
like $c.remote-host, /\S/, 'c.remote-host';
is $c.server-protocol, 'HTTP/1.1', 'c.server-protocol';
is $c.server-port, $serv-port, 'c.server-port';
is $c.server-addr, $serv-addr, 'c.server-addr';

is $c.virtual-host, $serv-name, 'c.virtual-host';
is $c.protocol, 'HTTP', 'c.protocol';
is $c.virtual-port, $serv-port, 'c.virtual-port';

done-testing;
=finish

$c.referer;
$c.remote-ident;
$c.auth-type;
$c.remote-user;
$c.user-name;
