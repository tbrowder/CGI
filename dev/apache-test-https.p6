#!/usr/bin/env perl6

use HTTP::UserAgent;

my $debug = 0;

my $protocol = 'https';
# this depends on one's server setup:
my $url  = 'cgi-bin-cmn/show-env.cgi';
my $host = 'usafa-1965.org'; # apache2

my $client = HTTP::UserAgent.new;
$client.timeout = 1;

my $resp = $client.get("$protocol://$host/$url");
my $stat = $resp.status-line;
if !$resp.is-success {
    say "FATAL: Unsuccessful response from '$host/$url'";
    exit;
}

my $body = $resp.content;
my %env;
my $max = 0; # for pretty printing
for $body.lines -> $line is copy {
    next if $line !~~ /\S/;
    say "DEBUG: line = '$line'" if 0 && $debug;
    # each line should be two words: key : value

    # skip some lines
    my $idx = index $line, ':';
    my ($k, $v);
    if $idx.defined {
	$k = $line.substr: 0, $idx;
	$v = $line.substr: $idx+1;
	$k .= trim;
        my $nc = $k.chars;
        if $nc > $max {
            $max = $nc;
        }

	$v .= trim;
	%env{$k} = $v;
	say "$k => '$v'" if $debug;
    }
    else {
	say "WARNING: No separator char ':'for line: '$line'" if $debug > 1;
    }
}

# output (pretty print)
for %env.keys.sort -> $k {
    printf "%-*s => '{%env{$k}}'\n", $max, $k;
}
