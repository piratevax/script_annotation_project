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
use Bio::Seq;
use Bio::SeqIO;
use Bio::DB::EUtilities;

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

=head1 FUNCTION compute_ncbi

    compute ncbi 

=cut

sub compute_ncbi {
    my ($this) = @_;
    my $term = '"'.$this->get_geneSymbol.'[Gene Name] AND "'.$this->get_organism.'"[Orgaism]';
    my $factory = Bio::DB::EUtilities->new(-eutil => 'esearch',
	    -db => 'gene',
	    -term => $term,
	    -email => 'mymail@foo.bar');
    print "count ncbi: ".$factory->get_count."\n";
    my @ids = $factory->get_ids;
    print "id ncbi: ".$ids[0]."\n";
#    $this->{NCBI_ID} = \@ids;
    my $factory2 = Bio::DB::EUtilities->new(-eutil => 'egquery',
	    -email => 'mymail@foo.bar',
	    -term => $term);
    print "egquery:\n";
    $factory2->print_all;
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
