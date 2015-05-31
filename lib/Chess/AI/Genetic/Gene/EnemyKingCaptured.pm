package Chess::AI::Genetic::Gene::EnemyKingCaptured;

use Moose;
use namespace::autoclean;

extends 'Chess::AI::Genetic::Gene';

override '_build_name' => sub {
	return "Enemy King Captured";
};

has '+weight' => (
	is => 'ro',
	isa => 'Int',
	lazy => 1,
	default => sub {
		return 1000;
	},
);

has '+debug' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 1,
);

augment 'calculate_value' => sub {
	my $self       = shift;
	my $game_state = shift;

	#TODO: Is it OK that this returns 0 if the check is false, regardless of weight?
	my $value = $self->weight * $game_state->{op_status}{mate};

	return $value;
};


__PACKAGE__->meta->make_immutable;

1;



