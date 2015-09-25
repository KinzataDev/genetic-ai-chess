package Chess::GameControllerProcess;

use Moose;
use Chess::Moose;
use Chess::Utils::Log qw/ $util_log /;

use Chess::Schema::Result::Generation;
use Chess::Schema::Result::Strand;
use Chess::Schema::Result::Player;

use Chess::Player;
use Chess::Player::AI;
use Chess::AI::Genetic::Strand;
use Chess::GameController;

has '_schema' => (
	is      => 'rw',
	isa     => 'Chess::Schema',
	lazy    => 1,
	default => sub {
		return Chess::Moose->_schema;
	},
);

has 'generation' => (
	is      => 'ro',
	isa     => 'Chess::Schema::Result::Generation',
	lazy    => 1,
	builder => '_build_generation',
);

sub _build_generation {
	my $self = shift;
	$util_log->level_debug(
		message => "Trying to find generation using id: " . $self->generation_id,
		color   => $util_log->debug_white,
		level   => 2
	);
	return $self->_schema->resultset('Generation')->find( $self->generation_id );
}

has 'generation_id' => (
	is  => 'rw',
	isa => 'Int|Undef',
);

has 'strand_1_record' => (
	is      => 'rw',
	isa     => 'Chess::Schema::Result::Strand',
	lazy    => 1,
	builder => '_build_strand_1_record',
);

sub _build_strand_1_record {
	my $self = shift;
	if ( defined $self->player_1_record ) {
		$util_log->level_debug( message => "Using player 1's strand", color => $util_log->debug_white, level => 2 );

		return $self->player_1_record->strand;
	}
	elsif ( defined $self->generation ) {
		$util_log->level_debug(
			message => "Building strand 1 from generation",
			color   => $util_log->debug_white,
			level   => 2
		);

		my @ids = $self->_schema->resultset('Strand')->search( { generation_id => $self->generation_id } )
		  ->get_column('strand_id')->all;
		my $index = int( rand( scalar @ids ) );
		return $self->_schema->resultset('Strand')->find( $ids[$index] );
	}
}

has 'strand_2_record' => (
	is      => 'rw',
	isa     => 'Chess::Schema::Result::Strand',
	lazy    => 1,
	builder => '_build_strand_2_record',
);

sub _build_strand_2_record {
	my $self = shift;
	if ( defined $self->player_2_record ) {
		$util_log->level_debug( message => "Using player 2's strand", color => $util_log->debug_white, level => 2 );
		return $self->player_2_record->strand;
	}
	elsif ( defined $self->generation ) {
		$util_log->level_debug(
			message => "Building strand 2 from generation",
			color   => $util_log->debug_white,
			level   => 2
		);

		my @ids = $self->_schema->resultset('Strand')->search( { generation_id => $self->generation_id } )
		  ->get_column('strand_id')->all;
		my $index = int( rand( scalar @ids ) );
		return $self->_schema->resultset('Strand')->find( $ids[$index] );
	}
}

has 'strand_1' => (
	is      => 'rw',
	isa     => 'Chess::AI::Genetic::Strand',
	lazy    => 1,
	builder => '_build_strand_1',
);

sub _build_strand_1 {
	my $self = shift;
	if ( !defined $self->strand_1_record ) {
		die "Cannot determine strand to use for strand 1";
	}
	return $self->strand_1_record->build_strand();
}

has 'strand_2' => (
	is      => 'rw',
	isa     => 'Chess::AI::Genetic::Strand',
	lazy    => 1,
	builder => '_build_strand_2',
);

sub _build_strand_2 {
	my $self = shift;
	if ( !defined $self->strand_2_record ) {
		die "Cannot determine strand to use for strand 2";
	}
	return $self->strand_2_record->build_strand();
}

has 'player_1_record' => (
	is  => 'rw',
	isa => 'Chess::Schema::Result::Player|Undef',
);

has 'player_2_record' => (
	is  => 'rw',
	isa => 'Chess::Schema::Result::Player|Undef',
);

has 'player_1' => (
	is  => 'rw',
	isa => 'Chess::Player|Undef',
);

has 'player_2' => (
	is  => 'rw',
	isa => 'Chess::Player|Undef',
);

has 'record_games' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 'f'
);

sub process {
	my $self = shift;

	$self->_validate_players();

	my $player_1 = Chess::Player::AI->new(
		{
			name   => $self->player_1_record->name,
			strand => $self->strand_1,
		}
	);

	my $player_2 = Chess::Player::AI->new(
		{
			name   => $self->player_2_record->name,
			strand => $self->strand_2,
		}
	);

	$util_log->level_debug( message => "Players created.", color => $util_log->debug_green, level => 2 );

	$self->player_1($player_1);
	$self->player_2($player_2);

	$util_log->level_debug(
		message =>
		  sprintf( "Players %s and %s are starting a match", $self->player_1_record->id, $self->player_2_record->id ),
		color => $util_log->debug_green,
		level => 2,
	);

	#TODO In GC, create Match, allow it to be loaded from there
	my $game_controller = Chess::GameController->new(
		{
			player_white => $player_1,
			player_black => $player_2,
		}
	);

	$game_controller->_init();
	my $result = $game_controller->play_game;

	my $winner = $result->{winner};

	if ( $self->record_games ) {
		$util_log->level_debug( message => "Recording games...", color => $util_log->debug_green, level => 2 );
		if ( $winner->name eq $player_1->name ) {
			$self->player_1_record->mark_win();
		}
		else {
			$self->player_2_record->mark_win();
		}

		$self->player_1_record->mark_game_played();
		$self->player_2_record->mark_game_played();
	}

	$util_log->level_debug( message => "Done with match!", color => $util_log->debug_green, level => 2 );

	return;
}

sub _validate_players {
	my $self = shift;

	$util_log->level_debug(
		message => "Validating players and strands...",
		color   => $util_log->debug_green,
		level   => 2
	);

	if ( defined $self->player_1_record ) {
		if ( $self->player_1_record->strand_id != $self->strand_1_record->strand_id ) {
			die "Both a player 1 and strand 1 were defined on creation.";
		}
	}
	else {
		# Player wasn't defined, make sure another player doesn't exist for the strand.
		my $player_1 =
		  $self->_schema->resultset('Player')->search( { strand_id => $self->strand_1_record->id }, { rows => 1 } )
		  ->single;

		if ( !defined $player_1 ) {
			$util_log->level_debug(
				message => "Player 1 not defined, inserting",
				color   => $util_log->debug_green,
				level   => 2
			);
			$player_1 = $self->_schema->resultset('Player')->new_result( {} )->save({
				strand_id => $self->strand_1_record->id,
				name      => "AI_" . $self->strand_1_record->id,
			});
		}
		$self->player_1_record($player_1);
	}

	if ( defined $self->player_2_record ) {
		if ( $self->player_2_record->strand_id != $self->strand_2_record->strand_id ) {
			die "Both a player 2 and strand 2 were defined on creation.";
		}
	}
	else {
		# Player wasn't defined, make sure another player doesn't exist for the strand.
		my $player_2 =
		  $self->_schema->resultset('Player')->search( { strand_id => $self->strand_2_record->id }, { rows => 1 } )
		  ->single;

		if ( !defined $player_2 ) {
			$util_log->level_debug(
				message => "Player 2 not defined, inserting",
				color   => $util_log->debug_green,
				level   => 2
			);
			$player_2 = $self->_schema->resultset('Player')->new_result( {} )->save({
				strand_id => $self->strand_2_record->id,
				name      => "AI" . $self->strand_2_record->id,
			});
		}
		$self->player_2_record($player_2);
	}
	return;
}

1;
