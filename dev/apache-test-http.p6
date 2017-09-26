#!/usr/bin/env perl6

# try the CRO services to test my CGI module
#use Cro::HTTP::Server;
#use Cro::HTTP::Router;
use Cro::HTTP::Client;

if !@*ARGS {
    say qq:to/HERE/;
    Usage: $*PROGRAM-NAME: go

    Provides a test of CGI handling.
    HERE
    exit;
}

my $resp;
my $body;

# reuse defaults
my $client = Cro::HTTP::Client.new(headers => [ User-agent => 'Cro' ]);

# HTTP
my $host = 'localhost'; # apache2
#my $host = '127.0.0.1'; # apache2
my $port = 80;
my $host-port = "$host:$port";
#my $url = '/var/www/html/index.html';
my $url  = 'index.html';

$resp = await $client.get: "http://$host-port/$url";
$body = await $resp.body-text;
say "Response ===================================";
say $resp;
say "End Response ===============================";
say "Body =======================================";
say $body;
say "End Body ===================================";

my $url2 = 'cgi-bin/show-env.cgi';
$resp = await $client.get: "http://$host-port/$url2";
$body = await $resp.body-text;
say "Response ===================================";
say $resp;
say "End Response ===============================";
say "Body =======================================";
say $body;
say "End Body ===================================";

##### unused #####

=begin comment
$resp = await Cro::HTTP::Client.get: "http://$host-port/');
say "Resp is {$resp}";

$resp = await Cro::HTTP::Client.get: "http://$host-port/poster";
say "Resp is {$resp}";

$resp = await Cro::HTTP::Client.post: "http://$host-port/poster";
say "Resp is {$resp}";

$resp = await Cro::HTTP::Client.get: "http://$host-port/test";
say "Resp is:";
say $resp.Str;
$body = await $resp.body-text;
say "Body is:";
say $body;
=end comment
