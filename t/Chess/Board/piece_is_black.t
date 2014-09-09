#!/usr/bin/env perl

use Chess::Board;

use Test::More tests => 12;

my $rep = Chess::Board->new;

my $piece = 0x01;

is( $rep->piece_is_white($piece), 0, "Piece is black" );
is( $rep->piece_is_black($piece), 1, "Piece is black" );

$piece = 0x02;

is( $rep->piece_is_white($piece), 0, "Piece is black" );
is( $rep->piece_is_black($piece), 1, "Piece is black" );

$piece = 0x04;

is( $rep->piece_is_white($piece), 0, "Piece is black" );
is( $rep->piece_is_black($piece), 1, "Piece is black" );

$piece = 0x08;

is( $rep->piece_is_white($piece), 0, "Piece is black" );
is( $rep->piece_is_black($piece), 1, "Piece is black" );

$piece = 0x10;

is( $rep->piece_is_white($piece), 0, "Piece is black" );
is( $rep->piece_is_black($piece), 1, "Piece is black" );

$piece = 0x20;

is( $rep->piece_is_white($piece), 0, "Piece is black" );
is( $rep->piece_is_black($piece), 1, "Piece is black" );
