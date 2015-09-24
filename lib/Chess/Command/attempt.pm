package Chess::Command::attempt;
use Chess -command;

use strict;
use warnings;

use Chess::AttemptSetup;

sub opt_spec {
	return (
		[ "new_attempt|n", "Initialize a new attempt", ],
		[ "list|l", "List information on the previous attempts" ],
	);
}

sub description {
	return "Setup the next attempt at building a first generation";
}

sub validate_args {
	my ($self, $opt, $args) = @_;


	$self->usage_error("Options needed") unless keys %{$opt};
}

sub new_attempt {
	my $self = shift;

	my $setup = Chess::AttemptSetup->new();
	$setup->process();

	return;
}

sub list {
	my $self = shift;
# TODO:
	print STDERR "TODO: LIST\n";
	return;
}

sub execute {
	my ($self, $opt, $args) = @_;

	if( $opt->{new_attempt} ) {
		$self->new_attempt();
	}
	elsif( $opt->{list} ) {
		$self->list();
	}

	return;
}

1;

