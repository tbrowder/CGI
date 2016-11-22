#!/usr/bin/env perl6

use lib <.>;

use CGI-Source;
use Test;

my $c = CGI-Source.new;

isa-ok $c, CGI-Source;

is $c.http('context-document-root'),
  '/home/web-server-common/cgi-bin-cmn/';

done-testing
