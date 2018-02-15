#!/usr/bin/perl

use strict;
use warnings;
use HTTP::Tiny;
use JSON;
use Data::Dumper;

my ($http, $server, $response, $ext, $hash, $species, $symbol);

$http = HTTP::Tiny->new();
$species = 'homo sapiens';
$symbol = 'rad51';

$server = 'http://rest.ensembl.org';
#$ext = "/lookup/symbol/Homo_sapiens/BRCA2?expand=1";
$ext = '/lookup/symbol/'.join('_', split(' ', $species)).'/'.$symbol.'?expand=1';
$response = $http->get($server.$ext, {
    headers => { 'Content-type' => 'application/json' }
});
 
die "Failed!\n" unless $response->{success};
 
if(length $response->{content}) {
    $hash = decode_json($response->{content});
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 1;
    print Dumper $hash;
    print "\n";
}
