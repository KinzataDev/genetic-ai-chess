package Chess::Role::Result::Player;

# ABSTRACT: Player result methods

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
		name
	  /;

	my @optional = qw/
		strand_id
		wins
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

	$data = $self->_validate($data, 'Player');

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
		die "Caught error while saving Player: $_";
	};

	return $self;
}

=head2 mark_game_played

=cut

sub mark_game_played {
	my $self = shift;

	if( defined $self->strand ) {
		$self->strand->mark_game_played();
	}
	return;
}

=head2 mark_win

=cut

sub mark_win {
	my $self = shift;

	if( defined $self->strand ) {
		$self->strand->mark_win();
	}

	$self->save( { wins => $self->wins + 1 } );
	return;
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
