package Chess::AI::Genetic::Gene;

use Moose;
use namespace::autoclean;

use Chess::Utils::Log qw/ $util_log /;

has 'name' => (
	is => 'ro',
	isa => 'Str',
	lazy_build => 1,
);

sub _build_name {
	my $package = shift;
	die "$package requires override of '_build_name'";
}

has 'debug' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 0,
);

has 'weight' => (
	is => 'rw',
	isa => 'Num',
	lazy => 1,
	default => sub {
		return 1;
	},
);

sub calculate_value {
	my $self        = shift;
	my $status_hash = shift;

	# Override and do stuff;
	my $augmented_value = inner($status_hash);

	$util_log->level_debug(
		message => sprintf("%-30s - WEIGHT: %3.3d - VALUE: %d", $self->name, $self->weight, $augmented_value),
		level   => 3,
		color   => $util_log->debug_yellow,
	) if $self->debug;

	return $augmented_value;
}


__PACKAGE__->meta->make_immutable;

1;
