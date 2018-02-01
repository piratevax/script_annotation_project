# --- DataAnalysis.pm ---
package DataAnalysis;
use strict;
use warnings;

=head1 FUNCTION new

    constructeur

=cut

sub new {
    my ($class, $geneSymbol, $organism) = @_;
    my $this = {};
    bless ($this, $class);
    $this->{GS} = $geneSymbol;
    $this->{ORGANISM} = $organism;
    return $this;
}

=head1 FUNCTION set_geneSymbol

    set variable : gene symbol

=cut

sub set_geneSymbol {
    my ($this, $geneSymbol);
    $this->{GS} = $geneSymbol;
}

=head1 FUNCTION set_orgnaism

    set variable : organism

=cut

sub set_organism {
    my ($this, $organism);
    $this->{ORGANISM} = $organism;
}

=head1 FUNCTION get_

    get variable : 

=cut

sub get_ {

}


=head1 FUNCTION compute_ncbi

    compute ncbi 

=cut

sub compute_ncbi {

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
