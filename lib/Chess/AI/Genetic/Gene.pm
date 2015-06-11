package Chess::AI::Genetic::Gene;

use Moose;
use namespace::autoclean;

use Chess::Utils::Log qw/ $util_log /;

has 'id' => (
	is => 'rw',
	isa => 'Int',
	required => 1,
);

has 'name' => (
	is => 'rw',
	isa => 'Str',
	lazy => 1,
	default => "Not Named",
);

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

=head2

Defines whether this gene can mutate.  Set this to false for genes that shouldn't get tweaked in
unexpected ways.

=cut

has 'can_mutate' => (
	is      => 'rw',
	isa     => 'Bool',
	lazy    => 1,
	default => 1,
);

has 'max_range' => (
	is      => 'rw',
	isa     => 'Num',
	lazy    => 1,
	default => 20000,
);

has 'min_weight' => (
	is      => 'rw',
	isa     => 'Num',
	lazy    => 1,
	default => -10000,
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

=head2

Provides the ability for the gene to specify what should happen if it is selected for mutation.

=cut

sub mutate {
	my $self = shift;

	return $self->weight;
}

sub to_hash {
	my $self = shift;

	return {
		id => $self->id,
		name => $self->name,
		weight => $self->weight,
		can_mutate => $self->can_mutate,
		max_range => $self->max_range,
		min_weight => $self->min_weight,
		module_name => __PACKAGE__,
	};
}

__PACKAGE__->meta->make_immutable;

1;
