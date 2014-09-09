package Chess::Player;

use Moose;
use namespace::autoclean;

sub move {
	my $self = shift;
	my $opts = shift;

	my $game_state = $opts->{state};


	return "";
}

__PACKAGE__->meta->make_immutable;

1;
