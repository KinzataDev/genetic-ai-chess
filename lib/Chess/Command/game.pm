package Chess::Command::game;

use Chess -command;

use Chess::AIController;

sub description {
	return "Run a test game";
}

sub execute {
	my $self = shift;

	my $controller = Chess::AIController->new();

	$controller->_init();

	$controller->play_game;

	return;
}

1;
