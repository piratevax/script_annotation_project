#!/usr/bin/perl

use warnings;
use strict;
use LWP::Simple;

sub main {
    my ($db, $dbGn, $dbGe, $dbNc, $dbNd, $dbP, $dbB, $term, $docsums, $flag);#, $base, $url, $web, $key, $data, $output;

    $term = '(rad51[Gene Name]) AND homo sapiens[Organism]';

# Download PubMed records that are indexed in MeSH for both asthma and 
# leukotrienes and were also published in 2009.

    $dbGn = 'gene';
    $dbGe = 'genome';
    $dbNc = 'nuccore';
    $dbNd = 'nucleotide';
    $dbP = 'protein';
    $dbB = 'biosystems';

    $db = $dbB;
    $docsums = request($db, $term);
    print $docsums;
    if ($db eq 'gene') {
	foreach (split("\n", $docsums)) {
#print $1."\n" if(/<DocumentSummary uid="(.*?)">/);
	    print $1."\n" if(/<DocumentSummary uid="(.*?)">/);
	    print $1."\n" if(/<Description>(.*?)<\/Description>/);
        }
    }
    elsif($db eq 'protein'){
	foreach (split("\n", $docsums)) {
	    print $1."," if(/<Item Name="Caption" Type="String">(NP_.*?)<\/Item>/);
	}
	print "\n";
    }
    elsif($db eq 'nuccore'){
	foreach (split("\n", $docsums)) {
	    print $1."," if(/<Item Name="Caption" Type="String">(NM_.*?)<\/Item>/);
	}
	print "\n";
    }
    elsif($db eq 'nucleotide'){
	foreach (split("\n", $docsums)) {
	    print $1."," if(/<Item Name="Caption" Type="String">(NG_.*?)<\/Item>/);
	}
	print "\n";
    }
    elsif($db eq 'biosystems'){
	$flag = 0;
	foreach (split("\n", $docsums)) {
	    if(/<Item Name="externalid" Type="String">(hsa[^_].*?)<\/Item>/) {
		print $1." : ";
		$flag = 1;
		next;
	    }

	    if ($flag == 1) {
		print $1."\n" if(/<Item Name="biosystemname" Type="String">(.*?)<\/Item>/);
		$flag = 0;
	    }
	}
    }
    else {print $docsums;}

#link_ncbi($dbG, $dbP, '5888');

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
