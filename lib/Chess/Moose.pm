package Chess::Moose;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

class_has '_config' => (
	is         => 'rw',
	writer     => '_set_config',
	clearer    => '_clear_config',
	lazy_build => 1,
);

sub _build__config {
	my $class = shift;

	require Chess::Config;

	return Chess::Config->_config;
}

class_has '_schema' => (
	is => 'rw',
	isa => 'DBIx::Class::Schema',
	writer => '_set_schema',
	clearer => '_clear_schema',
	lazy_build => 1,
);

sub _build__schema {
	my $class = shift;

	require Chess::Schema;

	# Allow options to be set. This is a hashref.
	my %options = ();
	if ( defined $class->_config()->{'DB'}{options} ) {
		%options = map { $_ => $class->_config()->{'DB'}{options}{$_} } keys %{$class->_config()->{'DB'}{options}};
		return Chess::Schema->connect( @{ $class->_config()->{'DB'}{connect_info} }, \%options );
	}

	return Chess::Schema->connect( @{ $class->_config()->{'DB'}{connect_info} }, );
}

1;
