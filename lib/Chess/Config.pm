package Chess::Config;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

use Dir::Self;
use Config::General;

class_has 'filename' => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub {
		return 'chess.conf';
	},
);

class_has '_config' => (
	is => 'ro',
	isa => 'HashRef',
	lazy_build => 1,
);

sub _build__config {

	my $config = Config::General->new( __DIR__ . "/../../" . Chess::Config->filename);

	return $config->{config};
}

__PACKAGE__->meta->make_immutable;

1;
