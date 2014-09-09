package Chess::AI::Genetic::Strand;

use Moose;
use namespace::autoclean;

has 'genes' => (
	is => 'ro',
	isa => 'ArrayRef[Chess::AI::Genetic::Gene]',
	lazy => 1,
	default => sub {
		return Chess::AI::Genetic::Gene::EnemyPieces->new();
	},
);

sub calculate_best_move {
	my $self = shift;
	my $opts = shift;

	my $player_state = $opts->{player_state};
	my $opponent_state = $opts->{opponent_state};

#	my $game_state = "";
#	TODO: Combine into something the Gene's can use


	# for each move
	# 	for each gene
	# 		get value
	# 	sum values
	#
	# Pick best move
}


__PACKAGE__->meta->make_immutable;

1;
