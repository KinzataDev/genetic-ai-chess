package Chess::AIController;

use Moose;
use namespace::autoclean;

use Chess::Player::AI;
use Chess::Board;

use constant {
	WHITE_MOVE => 128,
	BLACK_MOVE => 0,
};

has 'player_white' => (
	is => 'rw',
	isa => 'Chess::Player',
	lazy => 1,
	default => sub {
		return Chess::Player::AI->new();
	},
);

has 'player_black' => (
	is => 'rw',
	isa => 'Chess::Player',
	lazy => 1,
	default => sub {
		return Chess::Player::AI->new();
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
	$self->player_white( Chess::Player::AI->new() );
	$self->player_black( Chess::Player::AI->new() );

	return;
}

sub play_game {
	my $self = shift;

	my $turns = 0;

	while( !$self->board->is_check && ($turns < 1000) ) {
		$turns++;
		$self->play_turn;
	}

	use DDP; p $self->board->rep->dump_pos();
}

sub play_turn {
	my $self = shift;

	my $move;
	my $state       = $self->board->status;
	my $player_turn = $self->board->to_move();

	if ( $player_turn == WHITE_MOVE ) {
		print STDERR "WHITE MOVE\n";
		$move = $self->player_white->move( { state => $state } );
	}
	else {
		print STDERR "BLACK MOVE\n";
		$move = $self->player_black->move( { state => $state } );
	}

	$self->board->go_move($move);
	use DDP; p $move;
}

1;
