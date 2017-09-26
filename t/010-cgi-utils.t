#!/usr/bin/env perl6

use Test;

use lib <../dev dev>;

use CGI-Source;

plan 3;

my $c = CGI-Source.new;

use-ok 'CGI';
isa-ok $c, CGI-Source;

my $res;
lives-ok { my $res = $c.http(:parameter<context-document-root>); }

#=begin pod
like $res,
  /^ '/home/web-server-common/cgi-bin-cmn/' /;
#=end pod
