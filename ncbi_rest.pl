#!/usr/bin/perl

use warnings;
use strict;
use LWP::Simple;

sub main {
my ($db, $term, $docsums);#, $base, $url, $web, $key, $data, $output);

$term = '(rad51[Gene Name]) AND homo sapiens[Organism]';

# Download PubMed records that are indexed in MeSH for both asthma and 
# leukotrienes and were also published in 2009.

$db = 'protein';

$docsums = request($db, $term);
if ($db eq 'gene') {
    foreach (split("\n", $docsums)) {
        print $1."\n" if(/<DocumentSummary uid="(.*?)">/);
	print $1."\n" if(/<NomenclatureName>(.*?)<\/NomenclatureName>/);
    }
}
else {print $docsums;}
}

sub request {
    my ($db, $term) = @_;
    my ($base, $url, $output, $web, $key);

    #assemble the esearch URL
    $base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
    $url = $base . "esearch.fcgi?db=$db&term=$term&usehistory=y";
    #post the esearch URL
    $output = get($url);
    #parse WebEnv and QueryKey
    $web = $1 if ($output =~ /<WebEnv>(\S+)<\/WebEnv>/);
    $key = $1 if ($output =~ /<QueryKey>(\d+)<\/QueryKey>/);

    ### include this code for ESearch-ESummary
    #assemble the esummary URL
    $url = $base . "esummary.fcgi?db=$db&query_key=$key&WebEnv=$web";

    #post the esummary URL
    return get($url);
}

main();
