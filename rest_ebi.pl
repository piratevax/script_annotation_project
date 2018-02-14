#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use Data::Dumper;
 
#curl -X GET --header 'Accept: text/csv' 'http://www.ebi.ac.uk/ebisearch/ws/rest/?query=gene_name:(pad4) AND species:(arabidopsis thaliana)'
use HTTP::Tiny;
 
my $http = HTTP::Tiny->new();
 
my $server = 'http://rest.ensemblgenomes.org';
my $ext = '/xrefs/symbol/homo_sapiens/rad51';#arabidopsis_thaliana/PAD4?';
my $response = $http->get($server.$ext, {
	  headers => { 'Content-type' => 'application/json' }
	  });
 
die "Failed!\n" unless $response->{success};
 
 
if(length $response->{content}) {
    my $hash = decode_json($response->{content});
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 1;
    print Dumper $hash;
    print "\n";
}
