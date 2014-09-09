package Chess::AI::Genetic::Gene::EnemyKingCheck;;

use Moose;
use namespace::autoclean;

extends 'Chess::AI::Genetic::Gene';

override 'calculate_value' => sub {
	my $self       = shift;
	my $game_state = shift;

	my $value = $self->weight;

	my $king_is_checked = 1;

	return $weight;
};

__PACKAGE__->meta->make_immutable;

1;

