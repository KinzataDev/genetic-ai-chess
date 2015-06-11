#! /usr/bin/env perl

use Chess::AI::Genetic::Strand;

use Test::More tests => 1;

subtest 'build from definition' => sub {
	my $definition = {
		1 => {
			id => 1,
			name => 'test 1',
			weight => 35,
			debug => 1,
			module_name => 'Chess::AI::Genetic::Gene',
			max_range => 100,
			min_weight => -100,
		},
		2 => {
			id => 2,
			name => 'test 2',
			weight => 40,
			debug => 0,
			module_name => 'Chess::AI::Genetic::Gene',
			max_range => 200,
			min_weight => -300,
		},
		3 => {
			id => 3,
			name => 'test 3',
			weight => 50,
			debug => 1,
			module_name => 'Chess::AI::Genetic::Gene',
			max_range => 300,
			min_weight => -300,
		},
	};

	my $strand = Chess::AI::Genetic::Strand->new(
		gene_definition => $definition,
	);

	my $genes_list = $strand->genes;
	my @sorted_genes = sort { $a->id <=> $b->id } @{$genes_list} ;

	is( $sorted_genes[0]->id, $definition->{1}{id} );
	is( $sorted_genes[1]->id, $definition->{2}{id} );
	is( $sorted_genes[2]->id, $definition->{3}{id}, "IDs match" );

	is( $sorted_genes[0]->name, $definition->{1}{name} );
	is( $sorted_genes[1]->name, $definition->{2}{name} );
	is( $sorted_genes[2]->name, $definition->{3}{name}, "Names match" );
};
