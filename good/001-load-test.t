use v6;
use Test;

use CGI;

plan 2;

use-ok 'CGI', 'use the module';
lives-ok { my $c = CGI.new; }, 'create a CGI class instance';
