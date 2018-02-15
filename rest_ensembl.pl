#!/usr/bin/perl

use strict;
use warnings;
use HTTP::Tiny;

my ($http, $server, $response, $hash);

$http = HTTP::Tiny->new();

$server = 'http://rest.ensembl.org';
$ext = '/lookup/symbol/homo_sapiens/BRCA2?expand=1';
$response = $http->get($server.$ext, {
    headers => { 'Content-type' => 'application/json' }
});
 
die "Failed!\n" unless $response->{success};
 
use JSON;
use Data::Dumper;
if(length $response->{content}) {
    $hash = decode_json($response->{content});
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 1;
    print Dumper $hash;
    print "\n";
}
