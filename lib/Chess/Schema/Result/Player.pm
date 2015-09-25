package Chess::Schema::Result::Player;

# ABSTRACT: DBIC table for Player
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Chess::Schema::Result';
with 'Chess::Role::Result::Player';

__PACKAGE__->table('player');
__PACKAGE__->add_columns(
	player_id => { data_type => 'uuid', },
	name      => { data_type => 'text', },
	strand_id => {
		data_type   => 'uuid',
		is_nullable => 1,
	},
	wins => {
		data_type     => 'int',
		default_value => 0,
	},
);

__PACKAGE__->set_primary_key(qw/ player_id /);
__PACKAGE__->uuid_columns(qw/player_id/);

__PACKAGE__->belongs_to(
	strand => 'Chess::Schema::Result::Strand',
	'strand_id',
	{ on_update => 'CASCADE', }
);

__PACKAGE__->has_many(
	player_matches => 'Chess::Schema::Result::MatchPlayer',
	{'foreign.player_id' => 'self.player_id'},
);

__PACKAGE__->many_to_many(
	matches => 'player_matches',
	'match'
);

1;

