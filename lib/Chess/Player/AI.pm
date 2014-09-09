package Chess::Player::AI;

use Moose;
use namespace::autoclean;

use Chess::Rep;
use Chess::Player;
extends 'Chess::Player';

has 'strand' => (
	is => 'ro',
	isa => 'Chess::AI::Genetic::Strand',
	lazy => 1,
	default => sub {
		return Chess::Logic::Strain->new();
	},
);

override 'move' => sub {
	my $self = shift;
	my $opts = shift;

	my $game_state = $opts->{state};

	my $move_list = $game_state->{moves};

	my $move_hash = $move_list->[int(rand(@{$move_list}))];

	my $move = lc Chess::Rep::get_field_id( $move_hash->{from} ) . lc Chess::Rep::get_field_id( $move_hash->{to} );

	return $move;
};

__PACKAGE__->meta->make_immutable;

1;
