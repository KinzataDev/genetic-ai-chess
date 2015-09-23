package Chess::Schema::Result::Generation;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Chess::Schema::Result';

__PACKAGE__->table('generation');
__PACKAGE__->add_columns(
	generation_id => { data_type => 'serial', },
	generation    => { data_type => 'int', },
	attempt       => {
		data_type   => 'int',
		is_nullable => 1,
	},
);

__PACKAGE__->set_primary_key(qw/generation_id/);

__PACKAGE__->has_many(
	strands => 'Chess::Schema::Result::Strand',
	{'foreign.generation_id' => 'self.generation_id'},
);

1;

