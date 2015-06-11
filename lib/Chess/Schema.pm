package Chess::Schema;

use Moose;
use namespace::autoclean;

extends DBIx::Class::Schema;

__PACKAGE__->meta->make_immutable;

1;
