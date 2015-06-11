#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Chess::AI::Genetic::Operator::Crossover::Uniform;
use Test::Chess::Data::Gene;

my $hash_1 = Test::Chess::Data::Gene->build_gene_definition();
my $hash_2 = Test::Chess::Data::Gene->build_gene_definition();

$hash_2->{1}{weight} = 400;
$hash_2->{2}{weight} = 500;
$hash_2->{3}{weight} = 600;

my $uniform = Chess::AI::Genetic::Operator::Crossover::Uniform->new();

my $children = $uniform->process( strands => [ $hash_1, $hash_2 ] );

# Child 

#use DDP; p $children;
