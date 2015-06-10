package Chess::AI::Genetic::Strand;

use Moose;
use namespace::autoclean;
use DDP;

use Chess::Config;
use Module::Load;

has 'genes' => (
	is => 'ro',
	isa => 'ArrayRef[Chess::AI::Genetic::Gene]',
	lazy => 1,
	default => sub {
		my $self = shift;

		my $gene_hash = Chess::Config->_config->{genes};

		my $genes = $self->_load_genes( $gene_hash );

		return $genes;
	},
);

sub calculate_move_value {
	my $self        = shift;
	my $status_hash = shift;
	my $total = 0;

	foreach my $gene ( @{$self->genes} ) {
		my $value = $gene->calculate_value( $status_hash );
		$total += $value;
	}

	return $total;
}

=head2 mutate

index : Int : Optional

Selects a gene and attempts to apply a mutation to it.  If the selected gene cannot be mutated
the method will attempt to select on randomly that can until it reaches the maximum number of checks

=cut

sub mutate {
	my $self = shift;
	my $args = @_;

	my $index = $args->{index} // int ( rand ( scalar $self->genes ) );

	my $gene_to_mutate = $self->genes->[$index];
	my $attempts = 0;

	while ( !$gene_to_mutate->can_mutate && $attempts < Chess::Config->_config->{mutation}{max_checks} ) {
		$gene_to_mutate = $self->genes->[ int ( rand ( scalar $self->genes ) ) ];
		$attempts++;
	}

	$gene_to_mutate->mutate();
	return $gene_to_mutate;
}

sub _load_genes {
	my $self = shift;
	my $genes = shift;

	my @imported_genes;

	foreach my $gene ( keys %{$genes} ) {
		my $mod = $gene;

		next unless $genes->{$gene}{enabled};
		autoload $mod;

		my $imported_gene = $mod->new(
			weight => $genes->{$gene}{weight},
			debug => $genes->{$gene}{debug},
			name => $genes->{$gene}{name},
		);

		push @imported_genes, $imported_gene;
	}

	return \@imported_genes;
}


__PACKAGE__->meta->make_immutable;

1;
