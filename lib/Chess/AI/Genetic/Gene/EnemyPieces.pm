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

has 'can_mutate' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 1,
);

has 'max_range' => (
	is      => 'rw',
	isa     => 'Num',
	lazy    => 1,
	default => 2000,
);

has 'min_weight' => (
	is      => 'rw',
	isa     => 'Num',
	lazy    => 1,
	default => -1000,
);

augment 'calculate_value' => sub {
	my $self        = shift;
	my $status_hash = shift;

	my $num_enemy_pieces = scalar @{$status_hash->{op_status}->{pieces}};

	return (16 - $num_enemy_pieces) * $self->weight;
};

override 'mutate' => sub {
	my $self = shift;

	return rand( $self->max_range ) + $self->min_weight;
};

__PACKAGE__->meta->make_immutable;

1;

