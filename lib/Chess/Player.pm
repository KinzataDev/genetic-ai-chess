package Chess::Player;

use Moose;
use namespace::autoclean;

has 'name' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
);

sub move {
	my $self = shift;
	my $opts = shift;

	my $game_state = $opts->{state};


	return "";
}

__PACKAGE__->meta->make_immutable;

1;
