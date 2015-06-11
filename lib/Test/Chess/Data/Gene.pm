package Test::Chess::Data::Gene;

sub build_gene_definition {
	return {
		1 => {
			id => 1,
			name => 'test 1',
			weight => 100,
			debug => 1,
			module_name => 'Chess::AI::Genetic::Gene',
			max_range => 100,
			min_weight => -100,
		},
		2 => {
			id => 2,
			name => 'test 2',
			weight => 200,
			debug => 0,
			module_name => 'Chess::AI::Genetic::Gene',
			max_range => 200,
			min_weight => -300,
		},
		3 => {
			id => 3,
			name => 'test 3',
			weight => 300,
			debug => 1,
			module_name => 'Chess::AI::Genetic::Gene',
			max_range => 300,
			min_weight => -300,
		},
	};
}

1;
