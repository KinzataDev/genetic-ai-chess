package Chess::GameController;

use Moose;
use namespace::autoclean;

use Chess::Player::AI;
use Chess::Board;
use Chess::Config;

use Chess::Utils::Log qw/ $util_log /;

use DDP;

use constant {
	WHITE_MOVE => 128,
	BLACK_MOVE => 0,
};

has 'config' => (
	is => 'rw',
	isa => 'HashRef',
	lazy => 1,
	default => sub {
		return Chess::Config->_config;
	},
);

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

#TODO:
#has 'match' => (
#	is		=> 'ro',
#	isa		=> 'Chess::Schema::Result::Player',
#	lazy    => 1,
#	default => sub {
#		my $self = shift;
#		return
#	},
#);


Chess::Utils::Log->init_logger();

sub _init {
	my $self = shift;

	$util_log->level_debug( message => "Setting up new game", color => $util_log->debug_green, );

	$self->board( Chess::Board->new() );
	if( !defined $self->player_white ) {
		$self->player_white( Chess::Player::AI->new( name => "Player_white" ) );
	}
	if( !defined $self->player_black ) {
		$self->player_black( Chess::Player::AI->new( name => "Player_black" ) );
	}

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

	my $to_move = 0;

	while( !$self->board->is_mate && ($turns < $self->config->{max_moves}) ) {
		$turns++;
		$util_log->level_debug( message => "Turn: $turns", level => 1, color => $util_log->debug_magenta, );
		$to_move = $self->board->to_move();
		$self->play_turn;
	}

	# $to_move is the winner

	$util_log->level_debug( message => "Game complete!", level => 1, color => $util_log->debug_green, );
	my $ref = $self->board->rep->dump_pos();
	$util_log->dump( title => "Final State:", ref => "\n$ref", level => 1, color => $util_log->debug_on_white . $util_log->debug_black );

	if( $turns == $self->config->{max_moves} ) {
		return { winner => undef, turns => $turns };
	}

	if ( $to_move == WHITE_MOVE ) {
		$util_log->level_debug( message => "Winner: WHITE - ". $self->player_white->name, level => 1, color => $util_log->debug_green, );
		return { winner => $self->player_white, turns => $turns };
	}
	else {
		$util_log->level_debug( message => "Winner: BLACK - ". $self->player_black->name, level => 1, color => $util_log->debug_green, );
		return { winner => $self->player_black, turns => $turns };
	}
}

sub play_turn {
	my $self = shift;

	my $move_hash;
	my $player_turn = $self->board->to_move();

	if ( $player_turn == WHITE_MOVE ) {
		$util_log->level_debug( message => "Player WHITE's move", level => 2, color => $util_log->debug_green, );
		$move_hash = $self->player_white->move( $self->board );
		$self->board->white_status( $move_hash->{status} );
	}
	else {
		$util_log->level_debug( message => "Player BLACK's move", level => 2, color => $util_log->debug_green, );
		$move_hash = $self->player_black->move( $self->board );
		$self->board->black_status( $move_hash->{status} );
	}

	my $ret_hash = $self->board->go_move( $move_hash->{move} );

	my $ref = $self->board->rep->dump_pos();
	$util_log->dump( title => "Current State:", ref => "\n$ref", level => 5, color => $util_log->debug_on_white . $util_log->debug_black );
}

1;
