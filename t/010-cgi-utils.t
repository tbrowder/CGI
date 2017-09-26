#!/usr/bin/env perl6

use Test;

use Cro::HTTP::Client;
use CGI;

# tests here use a live apache2 server (on the local host
# and on travis

#plan 3;

my $c = CGI.new:

my $res;
lives-ok { my $res = $c.http(:parameter<context-document-root>); }

#=begin comment
like $res,
  /^ '/home/web-server-common/cgi-bin-cmn/' /;
#=end comment

done-testing;

