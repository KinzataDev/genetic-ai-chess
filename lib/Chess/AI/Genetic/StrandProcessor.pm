package Chess::AI::Genetic::StrandProcessor;

use Moose;
use namespace::autoclean;

use Chess::AI::Genetic::Operator::Crossover::Uniform;

has 'strand_set ' => {
	is => 'ro',
	isa => 'ArrayRef[Chess::AI::Genetic::Strand]',
	required => 1,
};

has 'genetic_operator' => {
	is => 'rw',
	isa => 'Chess::AI::Genetic::Operator',
	lazy => 1,
	default => sub {
		return Chess::AI::Genetic::Operator::Crossover::Uniform->new();
	},
};

=head2 process

Takes the Strands from within the set and applies the given genetic operation to them.
The operation is expected to provide the number of strands needed to perform it's operation
and is allowed to return as many new strands as it likes.  These new strands will be returned
for insertion into the next generation.

=cut

sub process {
	my $self = shift;

	my $num_parents = $self->genetic_operator->strand_count;
	my @new_generation;

	#TODO: Piece by piece send in the given number of parents to be processed into children
	while ( scalar @{$self->strand_set} ) {
		my @strands;
		for( 1..$num_parents ) {
			push @strands, shift $self->strand_set;
		}

		my $children = $self->genetic_operator->process( strands => \@strands );

		push @new_generation, @{$children};
	}

	return \@new_generation;
}

__PACKAGE__->meta->make_immutable;

1;
