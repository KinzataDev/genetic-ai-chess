##!/usr/bin/env perl -d:NYTProf
#!/usr/bin/env perl

use Test::More;

use Chess::AIController;

my $controller = Chess::AIController->new();

$controller->_init();

$controller->play_game;

done_testing();
