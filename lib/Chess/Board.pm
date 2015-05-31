package Chess::Board;

use Moose;
use namespace::autoclean;

use Chess::Utils::Log qw/ $util_log /;

use Chess::Rep;

use constant {
	WHITE_MOVE   => 128,
	BLACK_MOVE   => 0,
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

has 'white_status' => (
	is => 'rw',
	isa => 'Maybe[HashRef]',
	lazy => 1,
	default => undef,
);

has 'black_status' => (
	is => 'rw',
	isa => 'Maybe[HashRef]',
	lazy => 1,
	default => undef,
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

	return $self->rep->go_move($move);
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

around 'status' => sub {
	my $orig = shift;
	my $self = shift;

	my $status = $self->$orig;

	my @moves_to_push = ();

	foreach my $move ( @{ $status->{moves} } ) {
		# Only bother checking pawns
		next unless ($move->{piece} & 0x01) == 0x01;

		# If the move is into the first or last row...
		next unless (($move->{to} & 0x70) == 0x70 || ($move->{to} < 0x10 ));

		# Then add to the move list, the 4 promotion moves
		push @moves_to_push, {
			%{$move},
			promote => '=Q',
		};
		push @moves_to_push, {
			%{$move},
			promote => '=R',
		};
		push @moves_to_push, {
			%{$move},
			promote => '=B',
		};
		push @moves_to_push, {
			%{$move},
			promote => '=N',
		};

	}

	if( scalar @moves_to_push ) {
		$util_log->level_debug( message => "Promotion moves added!", level => 2, color => $util_log->debug_red, );
		push @{$status->{moves}}, @moves_to_push;
	}

	return $status;
};

sub get_op_status {
	my $self   = shift;
	my $player = $self->to_move;

	my $status;

	$self->rep->{to_move} ^= 0x80;
	$self->rep->compute_valid_moves;
	$status = $self->status;
	$self->rep->{to_move} ^= 0x80;

	$self->rep->compute_valid_moves;

	return $status;
}

sub get_status_after_move {
	my $self = shift;
	my $move = shift;

	$util_log->level_debug( message => "Before test move - To Move: " . $self->to_move, level => 10, color => $util_log->debug_blue, );

	my $fen = $self->rep->get_fen;

	$self->go_move($move);

	$util_log->level_debug( message => "After test move - To Move: " . $self->to_move, level => 10, color => $util_log->debug_blue, );

	my $status_hash = {
		op_status => $self->status,
		my_status => $self->get_op_status,
	};

	$self->rep->set_from_fen($fen);

	$util_log->level_debug( message => "After fen reset - To Move: " . $self->to_move, level => 10, color => $util_log->debug_blue, );

	return $status_hash;
}

1;
