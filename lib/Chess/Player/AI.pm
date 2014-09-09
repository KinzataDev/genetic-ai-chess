package Chess::Player::AI;

use Moose;
use namespace::autoclean;
use DDP;

use Chess::Rep;
use Chess::Player;
use Chess::AI::Genetic::Strand;
extends 'Chess::Player';

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

	my $my_state = $board->status;
	my $op_state = $board->get_op_status;

	my $best_move;
	my @best_moves = ();
	my $best_move_value = -10000;

	my $move_list = $my_state->{moves};

	my $temp_move;
	my $move_value;

	foreach my $move ( @{$move_list} ) {
		$temp_move = lc Chess::Rep::get_field_id( $move->{from} ) . lc Chess::Rep::get_field_id( $move->{to} );
		$move_value = $self->calculate_move_value( $board, $temp_move );
		if( $move_value > $best_move_value ) {
			$best_move_value = $move_value;
			$best_move = $temp_move;
			@best_moves = ($temp_move);
		}
		elsif( $move_value == $best_move_value ) {
			push @best_moves, $temp_move;
		}
	}

	p $best_move_value;

	return @best_moves[ int(rand( scalar @best_moves )) ];;
};

sub calculate_move_value {
	my $self  = shift;
	my $board = shift;
	my $move  = shift;

	my $new_status_hash = $board->get_status_after_move( $move );

	return $self->strand->calculate_move_value( $new_status_hash );
}

__PACKAGE__->meta->make_immutable;

1;
