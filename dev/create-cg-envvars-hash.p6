#!/usr/bin/env perl6

my $debug  = 0;
my $create = 0;

# for creating two vars hash modules
my $if1 = 'cgi-http-envvars.txt';
my $if2 = 'cgi-https-envvars.txt';

my $of1 = 'HttpVars.pm6';
my $of2 = 'HttpsVars.pm6';

my $f2 = 'CGI-TEST-ENV.pm6';

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM   c[reate] [d[ebug]]

    Modes:

      create - uses $if1, $if2 to produce
                    $of1, $of2

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
    create($if1, $of1);
    create($if2, $of2);
    say qq:to/HERE/;
    Normal end. See output files

        $of1
        $of2

    which, if satisfactory, can be copied to

        ../lib/CGI

    HERE

    exit;
}


#### subroutines ####
sub create($if, $of) {
    my $fh = open $of, :w;

    # headers
    my $title;
    if $if eq 'cgi-http-envvars.txt' {
        $title = 'CGI::HttpVars';
    }
    elsif $if eq 'cgi-https-envvars.txt' {
        $title = 'CGI::HttpsVars';
    }
    else {
        die "FATAL: Unexpected input file '$if'";
    }


    $fh.print(qq:to/HERE/);
    unit module {$title};


    our \%vars is export = \%(
    HERE

    for $if.IO.lines -> $line {
	$fh.say: "    {$line},";
    }

    # ender
    $fh.say(q:to/HERE/);
    );
    HERE

} # create
