#! /usr/bin/env perl

use Chess::AI::Genetic::Gene;

use Test::More tests => 1;

subtest 'test to_hash' => sub {
	my $gene = Chess::AI::Genetic::Gene->new( id => 1 );

	my $hash = $gene->to_hash();

	is( $hash->{id}, $gene->id, "IDs match" );
	is( $hash->{name}, $gene->name, "name matches" );
};

