package Chess::AttemptSetup;

use Moose;
use Chess::Moose;

has '_schema' => (
	is		=> 'ro',
	isa		=> 'DBIx::Class::Schema',
	lazy    => 1,
	default => sub {
		return Chess::Moose->_schema;
	},
);

has 'num_strands' => (
	is		=> 'ro',
	isa		=> 'Int',
	lazy    => 1,
	default => sub {
		return Chess::Moose->_config->{setup}{generation}{strand_count};
	},
);

has 'attempt' => (
	is		=> 'ro',
	isa		=> 'Int',
	lazy    => 1,
	default => sub {
		my $self = shift;
		my $next_attempt_number = 1;
		my $current_attempt = $self->_schema->resultset('Generation')->search(
			{},
			{ rows => 1, order_by => { -DESC => 'generation_id' } }
		)->single;

		if( defined $current_attempt ) {
			$next_attempt_number = $current_attempt->attempt + 1;
		}

		return $next_attempt_number;
	},
);

sub process {
	my $self = shift;

	# Build new generation
	my $generation = $self->_schema->resultset('Generation')->new_result( {} )->save(
		{
			generation => 1,
			attempt    => $self->attempt,
		},
	);

	for( 1..$self->num_strands ) {
		# Create Strand Object
		my $strand = Chess::AI::Genetic::Strand->new({generation_id => $generation->generation_id});
		$strand->_randomize_weights;
		$strand->write_to_db;
	}

	return 1;
}

1;
