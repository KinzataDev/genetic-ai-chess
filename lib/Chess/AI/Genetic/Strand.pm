package Chess::AI::Genetic::Strand;

use Moose;
use namespace::autoclean;
use DDP;

use Chess::AI::Genetic::Gene::EnemyPieces;
use Chess::AI::Genetic::Gene::EnemyKingCheck;
use Chess::AI::Genetic::Gene::EnemyKingMate;
use Chess::AI::Genetic::Gene::EnemyKingCaptured;
use Chess::AI::Genetic::Gene::PlayerPiecesThreatened;

has 'genes' => (
	is => 'ro',
	isa => 'ArrayRef[Chess::AI::Genetic::Gene]',
	lazy => 1,
	default => sub {
		return [
			Chess::AI::Genetic::Gene::EnemyPieces->new(),
			Chess::AI::Genetic::Gene::EnemyKingCheck->new(),
			Chess::AI::Genetic::Gene::EnemyKingMate->new(),
			Chess::AI::Genetic::Gene::EnemyKingCaptured->new(),
			Chess::AI::Genetic::Gene::PlayerPiecesThreatened->new(),
		];
	},
);

sub calculate_move_value {
	my $self        = shift;
	my $status_hash = shift;
	my $total = 0;

	foreach my $gene ( @{$self->genes} ) {
		my $value = $gene->calculate_value( $status_hash );
		$total += $value;
	}

	return $total;
}


__PACKAGE__->meta->make_immutable;

1;
