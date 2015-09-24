package Chess::Transaction;;

use strict;
use warnings;

use Chess::Moose;

use Scalar::Util qw/ blessed /;
use Sub::Exporter -setup => {
	exports => [qw(transaction )],
};

=head2 transaction

=over

=item Arguments: &block, @block_args?

=item Return Value: The return value of &block

=back

Wrapper around L<DBIx::Class::Schema/txn_do>.  Has a function prototype defined
so that the code block doesn't need to be declared with C<sub>.

=cut

sub transaction (&;@) {
	Chess::Moose->_schema->txn_do( @_ );
}

1;

