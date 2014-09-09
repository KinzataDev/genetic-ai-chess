#!/usr/bin/env perl -d:NYTProf

use Test::More;

use Chess::AIController;

my $controller = Chess::AIController->new();

$controller->_init();

$controller->play_game;

done_testing();
