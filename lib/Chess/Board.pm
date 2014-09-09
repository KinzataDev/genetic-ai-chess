package Chess::Board;

use Moose;
use namespace::autoclean;

use Chess::Rep;

use constant {
	BLACK_PAWN   => 0x01,    # 1
	BLACK_KNIGHT => 0x02,    # 2
	BLACK_KING   => 0x04,    # 4
	BLACK_BISHOP => 0x08,    # 8
	BLACK_ROOK   => 0x10,    # 16
	BLACK_QUEEN  => 0x20,    # 32
	WHITE_PAWN   => 0x81,    # 129
	WHITE_KNIGHT => 0x82,    # 130
	WHITE_KING   => 0x84,    # 132
	WHITE_BISHOP => 0x88,    # 136
	WHITE_ROOK   => 0x90,    # 144
	WHITE_QUEEN  => 0xA0,    # 160
};

has 'piece_map' => (
	is      => 'ro',
	isa     => 'HashRef',
	lazy    => 1,
	default => sub {
		return {
			1   => "BLACK_PAWN",
			2   => "BLACK_KNIGHT",
			4   => "BLACK_KING",
			8   => "BLACK_BISHOP",
			16  => "BLACK_ROOK",
			32  => "BLACK_QUEEN",
			129 => "WHITE_PAWN",
			130 => "WHITE_KNIGHT",
			132 => "WHITE_KING",
			136 => "WHITE_BISHOP",
			144 => "WHITE_ROOK",
			160 => "WHITE_QUEEN",
		};
	},
);

has 'rep' => (
	is      => 'rw',
	isa     => 'Chess::Rep',
	lazy    => 1,
	default => sub {
		return Chess::Rep->new();
	},
);

sub to_move {
	my $self = shift;
	return $self->rep->to_move;
}

sub go_move {
	my $self = shift;
	my $move = shift;

	$self->rep->go_move($move);
}

sub is_check {
	my $self = shift;

	return $self->rep->status->{check};
}

sub is_mate {
	my $self = shift;

	return $self->rep->status->{mate};
}

sub piece_is_white {
	my $self  = shift;
	my $piece = shift;
	return ( ( $piece & 0x80 ) == 0x80 ) ? 1 : 0;
}

sub piece_is_black {
	my $self  = shift;
	my $piece = shift;
	return ( ( $piece & 0x80 ) == 0 ) ? 1 : 0;
}

sub get_piece_at {
	my $self = shift;
	my $row  = shift;
	my $col  = shift;

	return $self->rep->get_piece_at( $row, $col );
}

sub status {
	my $self = shift;

	return $self->rep->status;
}

sub get_op_status {
	my $self   = shift;
	my $player = $self->to_move;

	$self->rep->to_move( !$player );
	$self->rep->compute_valid_moves;

	my $status = $self->rep->status;

	$self->rep->to_move($player);
	$self->rep->compute_valid_moves;

	return $status;
}

sub get_status_after_move {
	my $self = shift;
	my $move = shift;

	my $fen = $self->rep->get_fen;
	$self->go_move($move);
	my $status_hash = {
		my_status => $self->status,
		op_status => $self->get_op_status,
	};
	$self->rep->set_from_fen($fen);

	return $status_hash;
}

1;
