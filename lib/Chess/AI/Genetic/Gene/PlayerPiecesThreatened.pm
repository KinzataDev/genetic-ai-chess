package Chess::AI::Genetic::Gene::PlayerPiecesThreatened;

use Moose;
use namespace::autoclean;

use Chess::Rep;

extends 'Chess::AI::Genetic::Gene';

has '+weight' => (
	is => 'ro',
	isa => 'Int',
	lazy => 1,
	default => sub {
		return -2;
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

	my $count = 0;

	foreach my $piece ( @{$game_state->{my_status}{pieces}} ) {
		my $is_attacked = exists $game_state->{op_status}{type_moves}{ $piece->{from} };
		$count++ if $is_attacked;
	}

	my $value = $self->weight * $count;

	return $value;
};


__PACKAGE__->meta->make_immutable;

1;




