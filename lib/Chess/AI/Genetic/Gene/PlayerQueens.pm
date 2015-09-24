package Chess::AI::Genetic::Gene::PlayerQueens;

use Moose;
use namespace::autoclean;
use DDP;

extends 'Chess::AI::Genetic::Gene';

use constant {
	WHITE_MOVE   => 128,
	BLACK_MOVE   => 0,
	BLACK_QUEEN  => 0x20,    # 32
	WHITE_QUEEN  => 0xA0,    # 160
};

has '+weight' => (
	is      => 'rw',
	isa     => 'Num',
	lazy    => 1,
	default => 20,
);

has '+debug' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 1,
);

augment 'calculate_value' => sub {
	my $self        = shift;
	my $status_hash = shift;

	my $count = 0;
	my $piece_to_check;
	my $my_player = $status_hash->{my_status}{to_move};

	if( $my_player == WHITE_MOVE ) {
		$piece_to_check = WHITE_QUEEN;
	}
	else {
		$piece_to_check = BLACK_QUEEN;
	}

	my $my_pieces = $status_hash->{my_status}{pieces};
	foreach my $piece ( @{$my_pieces} ) {
		$count++ if( $piece->{piece} == $piece_to_check );
	}

	return $count * $self->weight;
};

override 'mutate' => sub {
	my $self = shift;

	return rand( $self->max_range ) + $self->min_weight;
};

__PACKAGE__->meta->make_immutable;

1;

