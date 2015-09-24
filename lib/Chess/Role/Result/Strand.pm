package Chess::Role::Result::Strand;

# ABSTRACT: Strand result methods

use Moose::Role;

use Try::Tiny;
use Data::FormValidator::Constraints qw/ email /;
use Data::FormValidator::Constraints::DateTime qw/ to_datetime /;
use Data::FormValidator;

use Chess::Transaction transaction    => { -as => 'txn' };

=head1 ATTRIBUTES

=head2 _data_profile

=cut

has '_data_profile' => (
	is	  => 'ro',
	isa	 => 'HashRef',
	lazy	=> 1,
	builder => '_build_data_profile',
);

sub _build_data_profile {
	my $self = shift;

	my @required = qw/
		generation_id
		json_description
	  /;

	my @optional = qw/
		parent_1_id
		parent_2_id
		matches
		matches_won
	  /;

	if ( $self->in_storage ) {
		push @optional, @required;
		@required = qw//;
	}

	return {
		required => \@required,
		optional => \@optional,
		constraint_methods => {

		},
		defaults => {

		},
	};
}

=head1 METHODS

=head2 save

=cut

sub save {

	my $self = shift;
	my $data = shift;
	my $opts = shift;

	$data = $self->_validate($data, 'Strand');

	try {
		txn(
			sub {
				$self->set_columns($data);
				$self->update_or_insert;

				$self->discard_changes;
			}
		);
	}
	catch {
		die "Caught error while saving Strand $_";
	};

	return $self;
}

=head1 PRIVATE METHODS

=head2 _validate

Performs validation on the L</_data_profile>

=cut

sub _validate {
	my $self      = shift;
	my $data_r    = shift;
	my $data_path = shift;

	return unless ref $data_r eq 'HASH';

	my $data_profile = $self->_data_profile;

	return Data::FormValidator->check( $data_r, $data_profile, $data_path, )->valid;
}

1;
