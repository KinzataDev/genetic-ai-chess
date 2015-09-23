package Chess::Schema::Result::Match;

# ABSTRACT: DBIC table for Matches
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'Chess::Schema::Result';

__PACKAGE__->table('match');
__PACKAGE__->add_columns(
	match_id    => { data_type => 'uuid', },
	is_complete => {
		data_type     => 'boolean',
		default_value => 'f',
	},
	fen             => { data_type => 'text', },
	json_move_log   => { data_type => 'json', },
	number_of_moves => {
		data_type     => 'int',
		default_value => 0,
	},
	white_player_id => {
		data_type         => 'uuid',
	},
);

__PACKAGE__->set_primary_key(qw/ match_id /);

__PACKAGE__->has_many(
	match_players => 'Chess::Schema::Result::MatchPlayer',
	{ 'foreign.match_id' => 'self.match_id' },
);

__PACKAGE__->many_to_many(
	players => 'match_players',
	'player',
);

__PACKAGE__->belongs_to(
	white_player => 'Chess::Schema::Result::Player',
	{ 'foreign.player_id' => 'self.white_player_id' },
	{ on_update           => 'CASCADE', }
);

1;
