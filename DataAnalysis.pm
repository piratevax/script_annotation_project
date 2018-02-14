#!/usr/bin/perl

package DataAnalysis;

=head1 NAME

    DataAnalysis.pm

=head1 SYNOPSIS

    blabla

=head1 AUTHOR

    Xavier Bussell

=cut

#
# Imports
#

use strict;
use warnings;
use LWP::Simple;
use Bio::Seq;
use Bio::SeqIO;
#use Bio::DB::EUtilities;
#use Bio::DB::SoapEUtilities;
#use Bio::DB::RefSeq;

=head1 FUNCTION DataAnalysis->new()

    constructeur

=cut

#
# Constructor
#

sub new {
    my ($class, $geneSymbol, $organism) = @_;
    my $this = {};
    bless ($this, $class);
    $this->{GS} = $geneSymbol;
    $this->{ORGANISM} = $organism;
    return $this;
}

#
# Functions
#

=head1 FUNCTION DataAnalysis->set_geneSymbol()

    set variable : gene symbol

=cut

sub set_geneSymbol {
    my ($this, $geneSymbol) = @_;
    $this->{GS} = $geneSymbol;
}

=head1 FUNCTION set_orgnaism

    set variable : organism

=cut

sub set_organism {
    my ($this, $organism) = @_;
    $this->{ORGANISM} = $organism;
}

=head1 FUNCTION get_geneSymbol

    get variable : gene symbol

=cut

sub get_geneSymbol {
    my ($this) = @_;
    return $this->{GS};
}

=head1 FUNCTION get_organism

    get variable : organism

=cut

sub get_organism {
    my ($this) = @_;
    return $this->{ORGANISM};
}

=head1 FUCTION request_ncbi
    
    api request on NCBI

=cut

sub request_ncbi {
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

=head1 FUNCTION compute_ncbi

    compute ncbi 

=cut

sub compute_ncbi {
    my ($this) = @_;
    my ($term, $docsums, $tmp, $flag);
    my (@dbs, @ids, @fullName, @nm, @np);
    my %kegg;

#
    $term = '"'.$this->get_geneSymbol.'"[Gene Name] AND "'.$this->get_organism.'"[Organism]';
#$term = '(rad51[Gene Name]) AND homo sapiens[Organism]';

    @dbs = qw(gene nuccore protein biosystems);
    print "Computing on NCBI\n";
    foreach my $db (@dbs) {
	print "\tNCBI->".$db."\n";
	$docsums = request_ncbi($db, $term);
#print $docsums;
	if ($db eq 'gene') {
	    foreach (split("\n", $docsums)) {
#print $1."\n" if(/<DocumentSummary uid="(.*?)">/);
		push(@ids, $1) if(/<DocumentSummary uid="(.*?)">/);
	        push(@fullName, $1) if(/<Description>(.*?)<\/Description>/);
	    }
	}
	elsif($db eq 'protein'){
	    foreach (split("\n", $docsums)) {
		push(@np, $1) if(/<Item Name="Caption" Type="String">(NP_.*?)<\/Item>/);
	    }
	}
	elsif($db eq 'nuccore'){
	    foreach (split("\n", $docsums)) {
		push(@nm, $1) if(/<Item Name="Caption" Type="String">(NM_.*?)<\/Item>/);
	    }
	}
	elsif($db eq 'biosystems'){
	    $flag = 0;
	    foreach (split("\n", $docsums)) {
		if(/<Item Name="externalid" Type="String">(hsa[^_].*?)<\/Item>/) {
		    $tmp = $1;
		    $flag = 1;
		    next;
		}
		if ($flag == 1) {
		    $kegg{$tmp} = $1 if(/<Item Name="biosystemname" Type="String">(.*?)<\/Item>/);
		    $flag = 0;
		    next;
		}
	    }
	}
    }
    $this->{NCBI_ID} = \@ids;
    $this->{FULL_NAME} = \@fullName;
    $this->{NM} = \@nm;
    $this->{NP} = \@np;
    $this->{KEGG} = \%kegg;
}

=head1 FUNCTION get_ncbi_ids

    get ncbi ids

=cut

sub get_ncbi_ids {
    my ($this) = @_;
    return $this->{NCBI_IDS};
}

=head1 FUNCTION compute_kegg

    compute kegg

=cut

sub compute_kegg {

}


=head1 FUNCTION compute_refSeq

    compute RefSeq

=cut

sub compute_refSeq {
    my ($this) = @_;
    my @ids = ();
	my $dbG = 'gene';
	my $dbN = 'nucleotide';
	my $dbP = 'protein';
    #my $db = Bio::DB::RefSeq->new();
    #my $seq = $db->get_Seq_by_id($this->get_ncbi_ids); # RefSeq ID
    #print "accession is ", $seq->accession_number, "\n";
    my $factory = Bio::DB::EUtilities->new(-eutil => 'elink',
	-email => 'mymail@foo.bar',
	-db => $dbN,
	-dbfrom => $dbG,
#	-cmd => 'llinks',
#	-linkname => 'gene_nuccore_pos',
#	-linkname => 'gene_protein',
	-id => '5888');#@{$this->get_ncbi_ids});
    print "### ".${$this->get_ncbi_ids}[0]."\n";
    while (my $ds = $factory->next_LinkSet) {
	print "   Link name: ",$ds->get_link_name,"\n";
	print "Protein IDs: ",join(',',$ds->get_submitted_ids),"\n";
	print "    Nuc IDs: ",join(',',$ds->get_ids),"\n";
	push(@ids, $ds->get_ids);
#	while (my $linkout = $ds->next_UrlLink) {
#	    print "\tProvider: ", $linkout->get_provider_name, "\n";
#	    print "\tLink    : ", $linkout->get_url, "\n";
#	}
    }
    print "### ".$ids[0]." - ".$#ids."\n";
#    my $hist = $factory->next_History || die "Arghh!";
    $factory->reset_parameters(-eutil => 'esummary',
	-email => 'mymail@foo.bar',
	-id => @ids,
#	-history => $hist,
	-db => $dbN);
#   for my $ds ( $factory->get_DocSums) {
#       print "ID: ",$ds->get_id,"\n";
#       while (my $item = $ds->next_Item('flattened'))  {
#           printf("%-20s:%s\n", $item->get_name, $item->get_content) if $item->get_content;
#       }
#       print "\n";
#   }
    $factory->print_all;
}


=head1 FUNCTION compute_pfam

    compute pfam

=cut

sub compute_pfam {

}


=head1 FUNCTION compute_prosite

    compute prosite

=cut

sub compute_prosite {

}


=head1 FUNCTION compute_ensembl

    compute ensembl

=cut

sub compute_ensemble {

}

=head1 FUNCTION compute_geneOntology

    compute gene ontology

=cut

sub compute_geneOntology {

}


=head1 FUNCTION compute_uniProt

    compute uni prot

=cut

sub compute_uniProt {

}


=head1 FUNCTION compute_pdb

    compute pdb

=cut

sub compute_pdb {

}


=head1 FUNCTION compute_string

    compute string

=cut

sub compute_string {

}


1;
