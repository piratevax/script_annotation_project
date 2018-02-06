#!/usr/bin/perl

use Bio::SeqIO;
use Bio::EnsEMBL::Registry;

my $r = "Bio::EnsEMBL::Registry";
my $s = "Bio::SeqIO";

$r->load_registry_from_db(-host=>"ensembldb.ensembl.org",
	-user=>"anonymous",
	-verbose=>'0');
my $species = "homo sapiens";
my $name = "rad51";#"BRCC5";
my $db = "core";
my $gene_adaptor = $r->get_adaptor($species, $db, "gene");

my @genes = @{$gene_adaptor->fetch_all_by_external_name($name)};

print "*** $species\n";
my $out = '<H1>Genes</H1>';
my $out2 = '<H1>Transcript</H1>';
my $i = 0;
foreach $rep (@genes) {
	print "> ".$rep->display_id()."\t".$rep->start()."\t".$rep->end()."\n";
	$out .= '<a href="http://www.ensembl.org/'.join('_', split(' ', $species)).'/Gene/Summary?db='.$db.';g='.$rep->display_id().';r='.$rep->slice()->seq_region_name().':'.$rep->start().'-'.$rep->end().'">'.$rep->display_id().'</a><br>';
	print "*** ".$rep->slice()->seq_region_name()."\n";
	my $y=0;
	my @transcripts = @{$rep->get_all_Transcripts };
	foreach $rep2 (@transcripts) {
	    print $rep2->display_id()."\t".$rep2->start()."\t".$rep2->end()."\n";
		$out2 .= '<a href="http://www.ensembl.org/'.join('_', split(' ', $species)).'/Transcript/Summary?db='.$db.';g='.$rep->display_id().';r='.$rep->slice()->seq_region_name().':'.$rep2->start().'-'.$rep2->end().';t='.$rep2->display_id().'">'.$rep2->display_id().'</a><br>';
	}
}
print "Total number : ".scalar(@genes)."\n";

open(WEB, ">test.html") || die "test.html: $&";
print WEB $out.$out2;
close(WEB);
