package Chess::AI::Genetic::Operator::Crossover::Uniform;

use Moose;
use namespace::autoclean;

extends 'Chess::AI::Genetic::Operator';

has 'crossover_percentage' => (
	is => 'rw',
	isa => 'Num',
	lazy => 1,
	default => sub {
		return .5;
	},
);

augment 'process' => sub {
	my $self        = shift;
	my %args   		= @_;

	my $strands = $args{strands};
	my $child_hash = {};

	my ($parent_1, $parent_2) = @{$strands};

	my @index_keys = sort {$a <=> $b } keys %{$parent_1};

	foreach my $key ( @index_keys ) {
		my $take_parent_1 = ( rand > $self->crossover_percentage ) ? 1 : 0;
		my $child_weight = $take_parent_1 ? $parent_1->{$key}{weight} : $parent_2->{$key}{weight};

		$child_hash->{$key} = $parent_1->{$key};
		$child_hash->{$key}{weight} = $child_weight;
	}

	return $child_hash;
};

__PACKAGE__->meta->make_immutable;

1;
