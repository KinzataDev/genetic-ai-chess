package Chess::Command::game;

use Chess -command;

use Chess::GameController;

sub description {
	return "Run a test game";
}

sub execute {
	my $self = shift;

	my $controller = Chess::GameController->new();

	$controller->_init();

	$controller->play_game;

	return;
}

1;
