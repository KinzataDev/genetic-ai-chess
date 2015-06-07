package Chess::AI::Genetic::Strand;

use Moose;
use namespace::autoclean;
use DDP;

use Chess::Config;

use Chess::AI::Genetic::Gene::EnemyPieces;
use Chess::AI::Genetic::Gene::EnemyKingCheck;
use Chess::AI::Genetic::Gene::EnemyKingMate;
use Chess::AI::Genetic::Gene::EnemyKingCaptured;
use Chess::AI::Genetic::Gene::PlayerPiecesThreatened;
use Chess::AI::Genetic::Gene::EnemyPiecesThreatened;
use Chess::AI::Genetic::Gene::EnemyQueens;
use Chess::AI::Genetic::Gene::PlayerQueens;

has 'genes' => (
	is => 'ro',
	isa => 'ArrayRef[Chess::AI::Genetic::Gene]',
	lazy => 1,
	default => sub {
		my $self = shift;

		my $gene_hash = Chess::Config->_config->{genes};

		my $genes = $self->_load_genes( $gene_hash );

		return $genes;
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

sub _load_genes {
	my $self = shift;
	my $genes = shift;

	my @imported_genes;

	foreach my $gene ( keys %{$genes} ) {
		my $mod = $gene;

		next unless $genes->{$gene}{enabled};
		eval "require ($mod)";

		my $imported_gene = $mod->new(
				weight => $genes->{$gene}{weight},
				debug => $genes->{$gene}{debug},
		);

		use DDP; p $imported_gene;
		push @imported_genes, $imported_gene;
	}

	return \@imported_genes;
}


__PACKAGE__->meta->make_immutable;

1;
