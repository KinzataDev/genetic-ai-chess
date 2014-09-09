package Chess::AI::Genetic::Gene::EnemyPieces;

use Moose;
use namespace::autoclean;

extends 'Chess::AI::Genetic::Gene';

override 'calculate_value' => sub {
	my $self       = shift;
	my $game_state = shift;

	# do some funky math to determine how less
	# enemy pieces yields a higher number

	return $weight;
};

__PACKAGE__->meta->make_immutable;

1;

