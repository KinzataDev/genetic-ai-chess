package Chess::Schema;

use Moose;
use namespace::autoclean;

extends 'DBIx::Class::Schema';

our $VERSION = 1;

__PACKAGE__->load_namespaces;

1;
