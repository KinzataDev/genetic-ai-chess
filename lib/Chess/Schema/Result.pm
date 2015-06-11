package Chess::Schema::Result;

use Moose;
use namespace::autoclean;

extends DBIx::Class::Result;

__PACKAGE__->meta->make_immutable;

1;
