#!/usr/bin/env perl6

use lib <. ../lib>;

use CGI-Source;
use CGI::Vars;

use Test;

my $debug  = 0;
my $filter = 0;
my $test   = 0;

# defaults
my $if = 'CGI-Source.pm6';
my $of = 'CGI.pm6';
my $odir = '.';

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM   t[est] | f[ilter] [o[dir]=X] [d[ebug]]

    Modes:

      test   - runs tests on the CGI-Source class module using a local
               CGI vars hash

      filter - filters test lines out of $if to produce $of for web use

    Options:

      odir=X - where X is the desired output directory (default: '.');

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
    elsif $arg ~~ /:i ^o [dir]? '=' (<[\w+/_.]>+) $/ {
	$odir = ~$0;
	say "DEBUG: \$arg = 'odir=$odir'" if $debug;
    }
    elsif $arg ~~ /:i ^deb [ug]? $/ {
	$debug = 1;
	say "DEBUG: \$arg = 'debug'" if $debug;
    }
    else {
	die "FATAL: Unknown arg '$arg'";
    }
}

die "DEBUG exit" if $debug;

if $filter {
    filter();
    say qq:to/HERE/;
    Normal end. See output file

	   $odir/$of
    HERE

    exit;
}

my %env;
for %req-meta-vars.keys.sort -> $var {
    my $val = $var.lc;
    %env{$var} = $val;
    say $var if $debug > 1;
}
for %tls-vars.keys.sort -> $var {
    my $val = $var.lc;
    %env{$var} = $val;
    say $var if $debug > 1;
}

# now for the test
my $cgi = CGI-Source.new;
for %env.sort(*.key)>>.kv.flat -> $var is copy, $val {
    $var .= lc;
    say $var if $debug;
    my ($s, $frag);
    if $var ~~ /:i ^HTTP/ {
	$frag = 'http';
	$s = $cgi.http(:parameter($var));
    }
    elsif $var ~~ /^SSL/ {
	next;
	$frag = 'ssl';
	$s = $cgi.ssl(:parameter($var));
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
    my $fho = open "$odir/$of", :w;

    for $fhi.lines -> $line {
	# ignore or change certain lines
	if $line ~~ /^ \s* state / {
	    next;
	}
	elsif $line ~~ / for \s+ testing / {
	    next;
	}
	elsif $line ~~ / use \s+ 'CGI-TEST-ENV' \s* ';' / {
	    next;
	}
	elsif $line ~~ / unit \s+ class \s+ 'CGI-Source' \s* ';' / {
	    $fho.say: "### WARNING: This file is auto-generated from file 'CGI-Source.pm6'. ###";
	    $fho.say: "### WARNING: Any edits to this file will be lost.                    ###\n";
	    $fho.say: "unit class CGI;";
	    next;
	}

	# write others
	$fho.say: $line;
    }
} # filter
