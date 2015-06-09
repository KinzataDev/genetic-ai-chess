package Chess::Player::AI;

use Moose;
use namespace::autoclean;

use Chess::Rep;
use Chess::Player;
use Chess::AI::Genetic::Strand;
extends 'Chess::Player';

use Chess::Utils::Log qw/ $util_log /;

has 'strand' => (
	is => 'ro',
	isa => 'Chess::AI::Genetic::Strand',
	lazy => 1,
	default => sub {
		return Chess::AI::Genetic::Strand->new();
	},
);

override 'move' => sub {
	my $self = shift;
	my $board = shift;

	$util_log->level_debug( message => "Deciding on move...", level => 1, color => $util_log->debug_white, );

	my $my_state = $board->status;

	my $best_move;
	my @best_moves = ();
	my $best_move_value = -10000;

	my $move_list = $my_state->{moves};

	my $temp_move;
	my $move_hash;

	foreach my $move ( @{$move_list} ) {

		$temp_move = lc Chess::Rep::get_field_id( $move->{from} ) . lc Chess::Rep::get_field_id( $move->{to} );
		if ( defined $move->{promote} ) {
			$temp_move .= $move->{promote};
		}
		$move_hash = $self->calculate_move_value( $board, $temp_move );
		if ( $move_hash->{value} > $best_move_value ) {
			$best_move_value = $move_hash->{value};
			$best_move      = $move_hash;
			@best_moves     = ($move_hash);
		}
		elsif ( $move_hash->{value} == $best_move_value ) {
			push @best_moves, $move_hash;
		}
	}

	my $selected_move = @best_moves[ int(rand( scalar @best_moves )) ];

	$util_log->level_debug( message => "Picking move: $selected_move->{move}", level => 1, color => $util_log->debug_red, );
	return $selected_move;
};

sub calculate_move_value {
	my $self  = shift;
	my $board = shift;
	my $move  = shift;

	$util_log->level_debug( message => "=" x 15, level => 2, color => $util_log->debug_cyan, );

	my $new_status_hash = $board->get_status_after_move($move);

	$util_log->level_debug( message => "Checking move: $move", level => 2, color => $util_log->debug_cyan, );

	my $value = $self->strand->calculate_move_value($new_status_hash);

	return {
		move   => $move,
		value  => $value,
		status => $new_status_hash->{my_status},
	};
}

__PACKAGE__->meta->make_immutable;

1;
