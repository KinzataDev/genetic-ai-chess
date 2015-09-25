package Chess::Command::game;

use Chess -command;

use Chess::GameControllerProcess;
use Chess::Moose;

sub opt_spec {
	return (
		[ "generation_id|g=s", "Generation ID to use for strand selection"],
		[ "strand_1=s", "Strand 1 ID to use, not required unless specifc strands are desired"],
		[ "strand_2=s", "Strand 2 ID to use, not required unless specifc strands are desired"],
		[ "player_1=s", "Player 1 ID to use, not needed unless specific players are desired"],
		[ "player_2=s", "Player 2 ID to use, not needed unless specific players are desired"],
		[ "record|r=s", "Boolean, should the games get recorded in the database? (t|f)"],
	);
}

sub description {
	return "Run a test game";
}

sub validate_args {
	my ($self, $opt, @args) = @_;

	if( !defined $opt->{generation_id} && !defined $opt->{strand_1} && !defined $opt->{player_1} ) {
		$self->usage_error("At least one of (generation_id, strand_1, player_1) is required") unless keys %{$opt};
	}

	if( defined $opt->{strand_1} && !defined $opt->{strand_2} ) {
		$self->usage_error("If using strands, both strand_1 and strand_2 required") unless keys %{$opt};
	}

	if( defined $opt->{player_1} && !defined $opt->{player_2} ) {
		$self->usage_error("If using players, both player_1 and player_2 required") unless keys %{$opt};
	}
}

sub execute {
	my ($self, $opt, @args) = @_;

	my $schema = Chess::Moose->_schema;

	if( $opt->{strand_1} ) {
		$opt->{strand_1} = $schema->resultset('Strand')->find($opt->{strand_1});
	}

	if( $opt->{strand_2} ) {
		$opt->{strand_2} = $schema->resultset('Strand')->find($opt->{strand_2});
	}

	if( $opt->{player_1} ) {
		$opt->{player_1} = $schema->resultset('Player')->find($opt->{player_1});
	}

	if( $opt->{player_2} ) {
		$opt->{player_2} = $schema->resultset('Player')->find($opt->{player_2});
	}

	my $gcp;
	if( $opt->{player_1} ) {
		$gcp = Chess::GameControllerProcess->new(
			{
				player_1_record => $opt->{player_1},
				player_2_record => $opt->{player_2},
				record_games    => $opt->{record} // 0,
			}
		);
	}

	elsif( $opt->{strand_1} ) {
		$gcp = Chess::GameControllerProcess->new(
			{
				strand_1_record => $opt->{strand_1},
				strand_2_record => $opt->{strand_2},
				record_games    => $opt->{record} // 0,
			}
		);
	}

	else {
		$gcp = Chess::GameControllerProcess->new(
			{
				generation_id   => $opt->{generation_id},
				record_games    => $opt->{record} // 0,
			}
		);
	}

	$gcp->process;

	return;
}

1;
