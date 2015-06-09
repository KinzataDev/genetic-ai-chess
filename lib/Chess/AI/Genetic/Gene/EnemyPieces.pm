package Chess::AI::Genetic::Gene::EnemyPieces;

use Moose;
use namespace::autoclean;
use DDP;

extends 'Chess::AI::Genetic::Gene';

has '+debug' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 1,
);

augment 'calculate_value' => sub {
	my $self        = shift;
	my $status_hash = shift;

	my $num_enemy_pieces = scalar @{$status_hash->{op_status}->{pieces}};

	return (16 - $num_enemy_pieces) * $self->weight;
};

__PACKAGE__->meta->make_immutable;

1;

