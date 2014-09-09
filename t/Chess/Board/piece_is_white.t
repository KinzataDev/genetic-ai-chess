#!/usr/bin/env perl

use Chess::Board;

use Test::More tests => 12;

my $piece = 0x81;

my $rep = Chess::Board->new();

is( $rep->piece_is_white($piece), 1, "Piece is white" );
is( $rep->piece_is_black($piece), 0, "Piece is white" );

$piece = 0x82;

is( $rep->piece_is_white($piece), 1, "Piece is white" );
is( $rep->piece_is_black($piece), 0, "Piece is white" );

$piece = 0x84;

is( $rep->piece_is_white($piece), 1, "Piece is white" );
is( $rep->piece_is_black($piece), 0, "Piece is white" );

$piece = 0x88;

is( $rep->piece_is_white($piece), 1, "Piece is white" );
is( $rep->piece_is_black($piece), 0, "Piece is white" );

$piece = 0x90;

is( $rep->piece_is_white($piece), 1, "Piece is white" );
is( $rep->piece_is_black($piece), 0, "Piece is white" );

$piece = 0xA0;

is( $rep->piece_is_white($piece), 1, "Piece is white" );
is( $rep->piece_is_black($piece), 0, "Piece is white" );
