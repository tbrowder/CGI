#!/usr/bin/env perl6

my $debug  = 0;
my $create = 0;

# for creating a test %*ENV environment
my $if = 'collected-envvars-data.txt';
my $of = 'CGI-Utils-TEST-ENV-tmp.pm6';

my $f2 = 'CGI-Utils-TEST-ENV.pm6';

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM   c[reate] [d[ebug]]

    Modes:

      create - uses $if to produce $of for copying to $f2

    Options:

      debug  - for development

    HERE
    exit;
}

for @*ARGS -> $arg {
    if $arg ~~ /:i ^c [reate]? $/ {
	$create = 1;
	say "DEBUG: \$arg = 'create'" if $debug;
    }
    elsif $arg ~~ /:i ^d [ebug]? $/ {
	$debug = 1;
	say "DEBUG: \$arg = 'debug'" if $debug;
    }
    else {
	die "FATAL: Unknown arg '$arg'";
    }
}

if $create {
    create();
    say qq:to/HERE/;
    Normal end. See output file

      $of

    which can be compared to $f2
    for final results.

    HERE

    exit;
}


#### subroutines ####
sub create() {
    my $fho = open $of, :w;

    # headers
    my $headers = q:to/HERE/;
    unit module CGI-Utils-TEST-ENV;

    my %env = (
    HERE

    $fho.say: $headers;

    my $fhi = open $if, :r;
    for $fhi.lines -> $line {
	# ignore or change certain lines
	if $line ~~ /^ \s* '=' / {
	    next;
	}

	# write all others
	$fho.say: $line ~ ',';
    }

    # enders
    my $enders = q:to/HERE/;
    );

    sub get-env() is export {
	return %env;
    }
    HERE

    $fho.say: $enders;

} # create
