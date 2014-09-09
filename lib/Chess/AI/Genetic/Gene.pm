package Chess::AI::Genetic::Gene;

use Moose;
use namespace::autoclean;

has 'weight' => (
	is => 'rw',
	isa => 'Num',
	lazy => 1,
	default => sub {
		return 1;
	},
);

sub calculate_value {
	my $self       = shift;
	my $status_hash = shift;

	# Override and do stuff;

	return $self->weight;
}


__PACKAGE__->meta->make_immutable;

1;
