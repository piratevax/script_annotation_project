#!/usr/bin/perl

use Bio::SeqIO;
use Bio::EnsEMBL::Registry;
#use Bio::EnsEMBL::Compara;
use Data::Dumper;

my $R = "Bio::EnsEMBL::Registry";
my $s = "Bio::SeqIO";

$R->load_registry_from_db(-host=>"ensembldb.ensembl.org",
	-user=>"anonymous",
	-verbose=>'0');
my $species = "homo sapiens";
my $generalSpecies = "Multi";
my $name = "rad51";#"BRCC5";
my @db = qw(core compara);
my $gene_adaptor = $R->get_adaptor($species, $db[0], "gene");

my @genes = @{$gene_adaptor->fetch_all_by_external_name($name)};

print "*** $species\n";
my $outG = '<h1>Genes</h1>';
my $outT = '<h1>Transcript</h1>';
my $outP = '<h1>Protein</h1>';
my $outO = '<h1>Orthologuous</h1>';
my $outB = '<h1>Genome Browser</h1>';
my $semiC = ';';
my $dash = '-';
my $colon = ':';
my $rightA = '">';
my $ouverture = '<a href="http://www.ensembl.org/';
my $fermeture = '</a><br>';
my $htmlSpecies = join('_', split(' ', $species));
my $htmlG = '/Gene/Summary?';
my $htmlT = '/Transcript/Summary?';
my $htmlP = '/Transcript/SummaryProtein?';
my $htmlO = '/Gene/Compara_Ortholog?';
my $htmlB = '/Location/View?';
my $db = 'db=';
my $g = 'g=';
my $t = 't=';
my $p = 'p=';
my $r = 'r=';

foreach $gene (@genes) {
	print "> ".$gene->display_id()."\t".$gene->start()."\t".$gene->end()."\n";
	#$outG .= '<a href="http://www.ensembl.org/'.join('_', split(' ', $species)).'/Gene/Summary?db='.$db.';g='.$gene->display_id().';r='.$gene->slice()->seq_region_name().':'.$gene->start().'-'.$gene->end().'">'.$gene->display_id().'</a><br>';
	print "*** ".$gene->slice()->seq_region_name()."\n";
	$outG .= $ouverture.$htmlSpecies.$htmlG.$db.$db[0].$semiC.$g.$gene->display_id().$semiC.$r.$gene->slice()->seq_region_name().$colon.$gene->start().$dash.$gene->end().$rightA.$gene->display_id().$fermeture;

	my @transcripts = @{$gene->get_all_Transcripts };
	foreach $transcript (@transcripts) {
	    print $transcript->display_id()."\t".$transcript->start()."\t".$transcript->end()."\n";
		#$outT .= '<a href="http://www.ensembl.org/'.join('_', split(' ', $species)).'/Transcript/Summary?db='.$db.';g='.$gene->display_id().';r='.$gene->slice()->seq_region_name().':'.$transcript->start().'-'.$transcript->end().';t='.$transcript->display_id().'">'.$transcript->display_id().'</a><br>';
		$outT .= $ouverture.$htmlSpecies.$htmlT.$db.$db[0].$semiC.$g.$gene->display_id().$semiC.$r.$gene->slice()->seq_region_name().$colon.$transcript->start().$dash.$transcript->end().$semiC.$t.$transcript->display_id().$rightA.$transcript->display_id().$fermeture;
		if ( $transcript->translation() ) {
			print "### ".$transcript->translation()->stable_id()."\n";
			#$outP .= '<a href="http://www.ensembl.org/'.join('_', split(' ', $species)).'/Transcript/ProteinSummary?db='.$db.';g='.$gene->display_id().';p='.$transcript->translation()->stable_id().';r='.$gene->slice()->seq_region_name().':'.$transcript->start().'-'.$transcript->end().';t='.$transcript->display_id().'">'.$transcript->translation()->stable_id().'</a><br>';
			$outP .= $ouverture.$htmlSpecies.$htmlP.$db.$db[0].$semiC.$g.$gene->display_id().$semiC.$p.$transcript->translation()->stable_id().$semiC.$r.$gene->slice()->seq_region_name().$colon.$transcript->start().$dash.$transcript->end().$semiC.$t.$transcript->display_id().$rightA.$transcript->translation()->stable_id().$fermeture;
		}
		else { print "### pseudogene\n"; }
	}

	$outO .= $ouverture.$htmlSpecies.$htmlO.$db.$db[0].$semiC.$g.$gene->display_id().$semiC.$r.$gene->slice()->seq_region_name().$colon.$gene->start().$dash.$gene->end().$rightA."ortho".$fermeture;

	$outB .= $ouverture.$htmlSpecies.$htmlB.$db.$db[0].$semiC.$g.$gene->display_id().$semiC.$r.$gene->slice()->seq_region_name().$colon.$gene->start().$dash.$gene->end().$rightA."Brows".$fermeture;
}
print "Total number : ".scalar(@genes)."\n";

open(WEB, ">test.html") || die "test.html: $&";
print WEB $outG.$outT.$outP.$outO.$outB;
close(WEB);
