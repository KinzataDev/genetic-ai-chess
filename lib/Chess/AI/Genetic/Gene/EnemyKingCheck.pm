package Chess::AI::Genetic::Gene::EnemyKingCheck;

use Moose;
use namespace::autoclean;

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
	default => 1001,
);

has 'min_weight' => (
	is      => 'rw',
	isa     => 'Num',
	lazy    => 1,
	default => 1,
);

augment 'calculate_value' => sub {
	my $self       = shift;
	my $game_state = shift;

	#TODO: Is it OK that this returns 0 if the check is false, regardless of weight?
	my $value = $self->weight * $game_state->{op_status}{check};

	return $value;
};

override 'mutate' => sub {
	my $self = shift;

	my $mutate_value = rand( $self->max_range ) + $self->min_weight;

	return $mutate_value;
};

__PACKAGE__->meta->make_immutable;

1;

