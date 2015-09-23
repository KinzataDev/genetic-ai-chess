package Chess::Schema::Result::MatchPlayer;

# ABSTRACT: DBIC table for MatchPlayer link
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Chess::Schema::Result';

__PACKAGE__->table('match_player');
__PACKAGE__->add_columns(
	match_id => {
		data_type         => 'uuid',
	},
	player_id => {
		data_type         => 'uuid',
	},
);

__PACKAGE__->set_primary_key(qw/ match_id player_id /);

__PACKAGE__->belongs_to(
	match => 'Chess::Schema::Result::Match',
	'match_id',
	{ on_update => 'CASCADE', }
);

__PACKAGE__->belongs_to(
	player => 'Chess::Schema::Result::Player',
	'player_id',
	{ on_update => 'CASCADE', }
);

1;

