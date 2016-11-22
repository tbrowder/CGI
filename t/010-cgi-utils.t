#!/usr/bin/env perl6

use lib <.>;

use CGI-Utils-Template;
use Test;

my $c = CGI-Utils-Template.new;

isa-ok $c, CGI-Utils-Template;

is $c.http('context-document-root'),
  '/home/web-server-common/cgi-bin-cmn/';
