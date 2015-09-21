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

		my $genes;
		if ( defined $self->gene_definition ) {
			$genes = $self->_build_strand_from_definition ( $self->gene_definition );
		}
		else {
			$genes = $self->_load_default_genes( $gene_hash );
		}

		return $genes;
	},
);

=head2 gene_definition

Definition of a gene as stored in the database or loaded for a test

=cut

has 'gene_definition' => (
	is => 'ro',
	isa => 'HashRef|Undef',
	lazy => 1,
	default => sub {
		return undef;
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
	my %args = @_;

	my $index = $args{index} // int ( rand ( scalar @{$self->genes} ) );

	my $gene_to_mutate = $self->genes->[$index];
	my $attempts = 0;

	while ( !$gene_to_mutate->can_mutate && $attempts < Chess::Config->_config->{mutation}{max_checks} ) {
		$gene_to_mutate = $self->genes->[ int ( rand ( scalar $self->genes ) ) ];
		$attempts++;
	}

	$gene_to_mutate->weight( $gene_to_mutate->mutate() );
	return $gene_to_mutate;
}

sub get_gene_hash {
	my $self = shift;

	my $hash = {};

	foreach my $gene ( $self->genes ) {
		$hash->{$gene->id} = $gene->to_hash();
	}

	return $hash;
}

sub _build_strand_from_definition {
	my $self = shift;
	my $hash = $self->gene_definition;

	my @genes;

	foreach my $key ( keys %{$hash} ) {
		my $gene_hash = $hash->{$key};
		autoload $gene_hash->{module_name};

		push @genes, $gene_hash->{module_name}->new(
			weight  => $gene_hash->{weight},
			name    => $gene_hash->{name},
			id      => $gene_hash->{id},
			debug   => $gene_hash->{debug},
			max_range => $gene_hash->{max_range},
			min_weight => $gene_hash->{min_weight},
		);
	}

	return \@genes;
}

sub _load_default_genes {
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
			id   => $genes->{$gene}{id},
		);

		push @imported_genes, $imported_gene;
	}

	return \@imported_genes;
}


__PACKAGE__->meta->make_immutable;

1;
