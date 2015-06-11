package Chess::AI::Genetic::Operator;

use Moose;
use namespace::autoclean;

use Chess::Config;
use Chess::AI::Genetic::Strand;

use Chess::Utils::Log qw/ $util_log /;

has 'strand_count' => (
	is => 'rw',
	isa => 'Int',
	lazy => 1,
	default => sub {
		return Chess::Config->_config->{AI}{Genetic}{Operator}{default_count};
	},
);

sub process {
	my $self = shift;
	my %args = @_;

	my $strands = $args{strands};

	die sprintf("Number of strands incorrect, require: %d - given: %d", $self->strand_count, scalar @{$strands})
		unless scalar @{$strands} == $self->strand_count;

	my $children = inner();

	if( ref $children ne 'ARRAY' ) {
		$children = [ $children ];
	}

	$self->_handle_mutation( $children );

	return $children;
}

=head2 _handle_mutation

Because we're passing around the data instead of the classes, we can't simply call 'mutate' on the object.
This method will go through the children and build the strand in order to mutate it, then export it to a
hash again.

=cut

sub _handle_mutation {
	my $self = shift;
	my $children = shift;

	foreach my $child ( @{$children} ) {
		# Build strand
		my $strand = Chess::AI::Genetic::Strand->new( gene_definition => $child );
		$strand->mutate;
	}
}

__PACKAGE__->meta->make_immutable;

1;
