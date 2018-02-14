#!/usr/bin/perl 

use strict;
use warnings;

use Bio::Seq;
use Bio::SeqIO;
use DataAnalysis;
use Data::Dumper;

my $DEBUGG = 0;
my ($geneSymbol, $organism, $analysis);

$geneSymbol = "rad51";
$organism = "homo sapiens";

$analysis = DataAnalysis->new($geneSymbol, $organism);

print $analysis->get_geneSymbol." ".$analysis->get_organism."\n" if($DEBUGG);

$analysis->compute_ncbi;

print Dumper($analysis->get_ncbi_ids)."\n" if ($DEBUGG);
print Dumper($analysis);
