package Chess::AI::Genetic::Gene::PlayerPiecesDefended;

use Moose;
use namespace::autoclean;

use Chess::Rep;

extends 'Chess::AI::Genetic::Gene';

has '+weight' => (
	is => 'ro',
	isa => 'Int',
	lazy => 1,
	default => sub {
		return 1;
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
	my $move = shift;

	my $count = 0;

	my $rep = $game_state->{rep};
	my $player = $game_state->{my_status}{to_move};

	foreach my $piece ( @{$game_state->{my_status}{pieces}} ) {
		my $is_attacked = $rep->is_attacked($piece->{from}, $player);
		$count++ if $is_attacked;
	}

	my $value = $self->weight * $count;

	return $value;
};

override 'mutate' => sub {
	my $self = shift;

	return rand( $self->max_range ) - $self->min_weight;
};

__PACKAGE__->meta->make_immutable;

1;




