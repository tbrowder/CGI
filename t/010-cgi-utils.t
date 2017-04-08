#!/usr/bin/env perl6

use Test;

use lib <../dev dev>;

use CGI-Source;

my $c = CGI-Source.new;

use-ok 'CGI';
isa-ok $c, CGI-Source;

lives-ok { $c.http(:parameter<context-document-root>); }

=begin pod
like $res,
  /^ '/home/web-server-common/cgi-bin-cmn/' /;
=end pod

done-testing;
