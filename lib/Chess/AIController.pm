package Chess::AIController;

use Moose;
use namespace::autoclean;

use Chess::Player::AI;
use Chess::Board;

use DDP;

use constant {
	WHITE_MOVE => 128,
	BLACK_MOVE => 0,
};

has 'player_white' => (
	is => 'rw',
	isa => 'Chess::Player',
	lazy => 1,
	default => sub {
		return Chess::Player::AI->new( name => "Player_white");
	},
);

has 'player_black' => (
	is => 'rw',
	isa => 'Chess::Player',
	lazy => 1,
	default => sub {
		return Chess::Player::AI->new( name => "Player_black");
	},
);

has 'board' => (
	is => 'rw',
	isa => 'Chess::Board',
	lazy => 1,
	default => sub {
		return Chess::Board->new();
	},
);

sub _init {
	my $self = shift;

	$self->board( Chess::Board->new() );
	$self->player_white( Chess::Player::AI->new( name => "Player_white" ) );
	$self->player_black( Chess::Player::AI->new( name => "Player_black" ) );

	$self->board->white_status( $self->board->status );

	$self->board->to_move(BLACK_MOVE);
	$self->board->rep->compute_valid_moves;

	$self->board->black_status( $self->board->status );

	$self->board->to_move(WHITE_MOVE);
	$self->board->rep->compute_valid_moves;

	return;
}

sub play_game {
	my $self = shift;

	my $turns = 0;

	while( !$self->board->is_check && ($turns < 1000) ) {
		$turns++;
		$self->play_turn;
	}

	p $self->board->rep->dump_pos();
}

sub play_turn {
	my $self = shift;

	my $move_hash;
	my $player_turn = $self->board->to_move();

	if ( $player_turn == WHITE_MOVE ) {
		$move_hash = $self->player_white->move( $self->board );
		$self->board->white_status( $move_hash->{status} );
	}
	else {
		$move_hash = $self->player_black->move( $self->board );
		$self->board->black_status( $move_hash->{status} );
	}

	$self->board->go_move( $move_hash->{move} );
	p $move_hash->{move};
}

1;
