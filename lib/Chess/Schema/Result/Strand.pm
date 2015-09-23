package Chess::Schema::Result::Strand;

# ABSTRACT: DBIC table for Strand
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Chess::Schema::Result';

__PACKAGE__->table('strand');
__PACKAGE__->add_columns(
	strand_id     => { data_type => 'uuid', },
	generation_id => { data_type => 'int', },
	parent_1_id      => {
		data_type   => 'uuid',
		is_nullable => 1,
	},
	parent_2_id => {
		data_type   => 'uuid',
		is_nullable => 1,
	},
	json_description => { data_type => 'json', },
	matches          => {
		data_type     => 'int',
		default_value => 0,
	},
	matches_won => {
		data_type     => 'int',
		default_value => 0,
	},
);

__PACKAGE__->set_primary_key(qw/ strand_id /);

__PACKAGE__->belongs_to(
	generation => 'Chess::Schema::Result::Generation',
	'generation_id',
	{ on_update => 'CASCADE', }
);

__PACKAGE__->belongs_to(
	player => 'Chess::Schema::Result::Player',
	'strand_id',
	{ on_update => 'CASCADE', }
);

__PACKAGE__->belongs_to(
	parent_1 => 'Chess::Schema::Result::Strand',
	'parent_1_id',
	{ on_update => 'CASCADE', }
);

__PACKAGE__->belongs_to(
	parent_2 => 'Chess::Schema::Result::Strand',
	'parent_2_id',
	{ on_update => 'CASCADE', }
);

__PACKAGE__->has_many(
	children_strands => 'Chess::Schema::Result::Strand',
	[
		{'foreign.parent_1_id' => 'self.strand_id'},
		{'foreign.parent_2_id' => 'self.strand_id'},
	],
);



1;

