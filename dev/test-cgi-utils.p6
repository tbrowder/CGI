#!/usr/bin/env perl6

use lib <.>;

use CGI-Utils-Template;
use CGI-Vars;
use Test;

my $debug  = 0;
my $filter = 0;
my $test   = 0;

my $if = 'CGI-Utils-Template.pm6';
my $of = 'CGI-Utils.pm6';

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM   t[est] | f[ilter] [d[ebug]]

    Modes:

      test   - runs tests on the CGI-Utils-Template module using a local
               CGI vars hash

      filter - filters test lines out of $if to produce $of for web use

    Options:

      debug  - for development

    HERE
    exit;
}

for @*ARGS -> $arg {
    if $arg ~~ /:i ^f [ilter]? $/ {
	$filter = 1;
	$test   = 0;
	say "DEBUG: \$arg = 'filter'" if $debug;
    }
    elsif $arg ~~ /:i ^t [est]? $/ {
	$test   = 1;
	$filter = 0;
	say "DEBUG: \$arg = 'test'" if $debug;
    }
    elsif $arg ~~ /:i ^d [ebug]? $/ {
	$debug = 1;
	say "DEBUG: \$arg = 'debug'" if $debug;
    }
    else {
	die "FATAL: Unknown arg '$arg'";
    }
}

if $filter {
    filter();
    say qq:to/HERE/;
    Normal end. See output file

	   $of
    HERE

    exit;
}

my %env;
for %cgi.keys.sort -> $var {
    my $val = $var.lc;
    %env{$var} = $val;
    say $var if $debug > 1;
}
for %tls.keys.sort -> $var {
    my $val = $var.lc;
    %env{$var} = $val;
    say $var if $debug > 1;
}

# now for the test
for %env.sort(*.key)>>.kv.flat -> $var is copy, $val {
    $var .= lc;
    say $var if $debug;
    my ($s, $frag);
    if $var ~~ /:i ^HTTP/ {
	$frag = 'http';
	$s = http(:parameter($var));
    }
    elsif $var ~~ /^SSL/ {
	next;
	$frag = 'ssl';
	$s = ssl(:parameter($var));
    }

    if $s {
	say "{$frag}({$var}) = '$s'";
    }
    else {
	say "UNKNOWN VAR '$var'";
    }

    #say "$var => $val";
}

#### subroutines ####
sub filter() {
    my $fhi = open $if, :r;
    my $fho = open $of, :w;

    for $fhi.lines -> $line {
	# ignore or change certain lines
	if $line ~~ /^ \s* state / {
	    next;
	}
	elsif $line ~~ / for \s+ testing / {
	    next;
	}
	elsif $line ~~ / use \s+ 'CGI-Utils-TEST-ENV;' / {
	    next;
	}
	elsif $line ~~ / unit \s+ module \s+ 'CGI-Utils-Template;' / {
	    $fho.say: "unit module CGI-Utils;";
	    next;
	}

	# write others
	$fho.say: $line;
    }
} # filter
