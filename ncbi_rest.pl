#!/usr/bin/perl

use warnings;
use strict;
use LWP::Simple;

sub main {
    my ($dbG, $dbN, $dbP, $term, $docsums);#, $base, $url, $web, $key, $data, $output);

    $term = '(rad51[Gene Name]) AND homo sapiens[Organism]';

# Download PubMed records that are indexed in MeSH for both asthma and 
# leukotrienes and were also published in 2009.

    $dbG = 'gene';
    $dbN = 'nucleotide';
    $dbP = 'protein';

    $docsums = request($dbG, $term);
    if ($dbG eq 'gene') {
	foreach (split("\n", $docsums)) {
	    print $1."\n" if(/<DocumentSummary uid="(.*?)">/);
	    print $1."\n" if(/<NomenclatureName>(.*?)<\/NomenclatureName>/);
        }
    }
    else {print $docsums;}

    link_ncbi($dbG, $dbP, '5888');
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

sub link_ncbi {
    my ($dbfrom, $db, $ids) = @_;
    my ($linkname, $base, $url, $output, $docsums, $data, $web, $key);
    
    $linkname = 'protein_gene'; # desired link &linkname

#assemble the elink URL
    $base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
    $url = $base . "elink.fcgi?dbfrom=$dbfrom&db=$db&id=$ids";
    $url .= "&cmd=neighbor_history";

#post the elink URL
    $output = get($url);

#parse WebEnv and QueryKey
    $web = $1 if ($output =~ /<WebEnv>(\S+)<\/WebEnv>/);
    $key = $1 if ($output =~ /<QueryKey>(\d+)<\/QueryKey>/);

### include this code for ELink-ESummary
#assemble the esummary URL
    $url = $base . "esummary.fcgi?db=$db&query_key=$key&WebEnv=$web";

#post the esummary URL
    $docsums = get($url);
    print "$docsums";

### include this code for ELink-EFetch
#assemble the efetch URL
    $url = $base . "efetch.fcgi?db=$db&query_key=$key&WebEnv=$web";
    $url .= "&rettype=xml&retmode=xml";

#post the efetch URL
    $data = get($url);
    print "$data";
}

main();
