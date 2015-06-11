package Chess::AI::Genetic::Operator;

use Moose;
use namespace::autoclean;

use Chess::Config;

use Chess::Utils::Log qw/ $util_log /;

has 'strand_count' => {
	is => 'rw',
	isa => 'Int',
	lazy => 1,
	default => sub {
		return Chess::Config->_config->{AI}{Genetic}{Operator}{default_count};
	},
};


sub process {
	my $self = shift;
	my $args = @_;

	my $strands = $args->{strands};

	throw sprintf("Number of strands incorrect, require: %d - given: %d", $self->strand_count, scalar @{$strands})
		unless scalar @{$strands} == $self->strand_count;

	my $ret_value = inner( $strands );

	if( ref $ret_value ne 'ARRAY' ) {
		$ret_value = [ $ret_value ];
	}

	return $ret_value;
}


__PACKAGE__->meta->make_immutable;

1;
