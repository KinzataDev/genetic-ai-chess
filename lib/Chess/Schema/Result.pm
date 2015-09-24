package Chess::Schema::Result;

use Moose;
use namespace::autoclean;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(
	qw/
	  UUIDColumns
	  /
);

1;
