package Chess::GameManager;

use Moose;
use namespace::autoclean;

=head2 process

Main loop

TODO: Should this instead be a service?

=cut

sub process {
	my $self = shift;
	return 1;
}

#TODO: Select 2 strands, send MQ message to request a new game between them
sub build_match {

}


__PACKAGE__->meta->make_immutable;

1;
