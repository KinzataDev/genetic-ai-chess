package Chess::AI::Genetic::Operator::Crossover::Uniform;

use Moose;
use namespace::autoclean;

extends 'Chess::AI::Genetic::Operator';

augment 'process' => sub {
	my $self        = shift;
	my $parents     = shift;
	my $children    = ();

	my ($parent_1, $parent_2) = @{$parents};


	return $children;
};

__PACKAGE__->meta->make_immutable;

1;
