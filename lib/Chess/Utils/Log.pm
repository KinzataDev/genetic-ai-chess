package Chess::Utils::Log;
use strict;
use warnings;

use Exporter;
our @ISA    = 'Exporter';
our @EXPORT = qw/$util_log/;

use Log::Log4perl;
use Log::Any::Adapter;

# TEMP
use Dir::Self;

our $util_log = Chess::Utils::Log::Object->new();

sub init {
	my $self = shift;

	print "HIT";
	# TODO: Common path names
	Log::Log4perl::init( __DIR__ . "/../../../log4perl.conf" );
	Log::Any::Adapter->set('Log4perl');

	return;
}

{

	package Chess::Utils::Log::Object;

	use Moose;

	use Log::Any qw/ $log /;
	use Term::ANSIColor qw/:constants/;
	use POSIX;
	use Data::Dumper;
	use Devel::StackTrace;

	has 'use_color' => (
		is         => 'rw',
		isa        => 'Bool',
		lazy_build => 1,
	);

	sub _build_use_color {

		#TODO: return config value
		return 1;
	}

	has 'use_package' => (
		is         => 'rw',
		isa        => 'Bool',
		lazy_build => 1,
	);

	sub _build_use_package {

		#TODO: return config value
		return 1;
	}

	has 'use_timestamp' => (
		is         => 'rw',
		isa        => 'Bool',
		lazy_build => 1,
	);

	sub _build_use_timestamp {

		#TODO return config value
		return 1;
	}

	has 'verbose_level' => (
		is         => 'rw',
		isa        => 'Int',
		lazy_build => 1,
		trigger    => sub {
			my $self  = shift;
			my $value = shift;

			if ( $value > 0 ) {
				$log->debug("util log verbose level set to $value");
			}
		},
	);

	sub _build_verbose_level {
		my $self = shift;

		my $value = 5;

		if ( $value > 0 ) {
			$log->debug("util log verbose level set to $value");
		}

		#TODO return config value
		return $value;
	}

	has 'output' => (
		is         => 'rw',
		isa        => 'Str',
		lazy_build => 1,
	);

	sub _build_output {
		my $self = shift;

		#TODO return config value
		return "Log4perl";;
	}

	has '_magic' => (
		is => 'ro',
		isa => 'Object',
		lazy_build => 1,
		handles => [
			qw/
				trace
				debug
				info
				warnings
				error
				fatal
				log
				is_trace
				is_debug
				is_info
				is_warn
				is_error
				is_fatal
				logdie
				logwarn
				error_warn
				error_die
				logcarp
				logcluck
				logcroakk
				logconfess
			/
		],
	);

	sub _build__magic {
		return $log;
	}

	sub debug_bold  { return BOLD; }
	sub debug_blink { return BLINK; }

	sub debug_black     { return BLACK; }
	sub debug_red       { return RED; }
	sub debug_green     { return GREEN; }
	sub debug_yellow    { return YELLOW; }
	sub debug_blue      { return BLUE; }
	sub debug_magenta   { return MAGENTA; }
	sub debug_cyan      { return CYAN; }
	sub debug_grey      { return WHITE; }
	sub debug_white     { return BOLD . WHITE; }
	sub debug_dark_grey { return BRIGHT_BLACK; }

	sub debug_on_black   { return ON_BLACK; }
	sub debug_on_red     { return ON_RED; }
	sub debug_on_green   { return ON_GREEN; }
	sub debug_on_yellow  { return ON_YELLOW; }
	sub debug_on_blue    { return ON_BLUE; }
	sub debug_on_magenta { return ON_MAGENTA; }
	sub debug_on_cyan    { return ON_CYAN; }
	sub debug_on_grey    { return ON_WHITE; }
	sub debug_on_white   { return ON_BRIGHT_WHITE; }

	sub _show_debug {
		my $self = shift;
		my $level = shift;

		return $self->verbose_level > $level;
	}

	sub timestamp {
		return POSIX::strftime( "%m/%d/%Y %H:%M:%S", localtime );
	}

	sub level_debug {

		my $self = shift;
		my %args = @_;

		my $color   = $args{color}          // $self->debug_white;
		my $level   = $args{level}          // 1;
		my $message = $args{message}        // "";
		my $depth = $args{depth} || 0;

		if ( $self->_show_debug($level) ) {

#			if ( $self->record ) {
#				$self->add_record_log( $self->timestamp() . " - " . $args{message} );
#			}

			if ( $self->use_package ) {
				my ( $package, $filename, $line ) = caller($depth);
				$message = $package . " - " . $line . " - " . $message;
			}
			if ( $self->use_color and defined $color ) {
				$message = $color . $message . RESET;
			}
#			if ( $self->indent ) {
#				$message = " " x ( $self->indent * 2 ) . $message;
#			}
			if ( $self->use_timestamp ) {
				$message = $self->timestamp() . " - $message";
			}

			if ( $self->output eq "STDERR" ) {
				print STDERR "$message\n";
			}
			elsif ( $self->output eq "STDOUT" ) {
				print "$message\n";
			}
			else {
				$log->debug($message);
			}
		}

		return;
	}

	sub here {

		my $self = shift;
		my %args = @_;

		my $color = $args{color} || RESET;
		my $level = $args{level} // 1;

		my ( $package, $filename, $line ) = caller;

		my $message = "HERE!!!!!";
		if ( not $self->use_package ) {
			my ( $package, $filename, $line ) = caller(0);
			$message .= " $package, $line";
		}

		$self->level_debug(
			message => BLINK . GREEN . "=====> " . RESET . $color . $message . RESET,
			level   => $level,
			depth   => 1
		);

		return;
	}

	sub dump {

		my $self = shift;
		my %args = @_;

		my $ref     = $args{ref};
		my $color   = $args{color} || $self->debug_on_red() . $self->debug_white();
		my $level   = $args{level} // 1;
		my $depth   = $args{depth} // 0;
		my $message = $args{title} // "DUMPER";

		# check here before doing the stuff below
		return if ( not $self->_show_debug($level) );

		my ( $package, $filename, $line ) = caller;

		if ( not $self->use_package ) {
			my ( $package, $filename, $line ) = caller(0);
			$message .= " $package, $line";
		}
		$message .= "\n";

		my $old_depth = $Data::Dumper::Maxdepth;
		my $old_sort  = $Data::Dumper::Sortkeys;
		$Data::Dumper::Sortkeys = 1;
		$Data::Dumper::Maxdepth = $depth;
		$message .= Dumper($ref);
		$Data::Dumper::Maxdepth = $old_depth;
		$Data::Dumper::Sortkeys = $old_sort;

		$self->level_debug(
			message => $message,
			level   => $level,
			color   => $color,
			depth   => 1
		);

		return;
	}

	sub caller {

		my $self = shift;
		my %args = @_;

		my $color = $args{color} // $self->debug_on_cyan() . $self->debug_black() . $self->debug_blink();
		my $level = $args{level} // 1;
		my $depth = $args{depth} || 0;

		my ( $package, $filename, $line ) = caller( $depth + 1 );

		$self->level_debug(
			message => sprintf( "--------> Called from %s, %s, %s [%d]", $package, $filename, $line, $depth ),
			level   => $level,
			color   => $color
		);
	}

	sub stack_trace {

		my $self = shift;
		my %args = @_;

		my $level = $args{level} // 1;

		if ( $self->_show_debug($level) ) {

			$self->level_debug(
				message      => Devel::StackTrace->new()->as_string,
				level        => $level,
				color        => $args{color} // $self->debug_on_red(),
				caller_level => 1
			);
		}
	}

	sub table_dump {

		my $self = shift;
		my %args = @_;

		my $model    = $args{model};
		my $criteria = $args{criteria};

		my $level = $args{level} // 1;
		my $color = $args{color} // $self->debug_green();

		if ( $self->_show_debug($level) ) {

			my @data =
			  Lexi::Moose->_schema->resultset($model)
			  ->search( $criteria, { result_class => 'DBIx::Class::ResultClass::HashRefInflator' } )->all();

			$self->dump( ref => \@data, level => $level, color => $color );
		}
	}

#	sub send_log {
#
#		my $self = shift;
#		my %args = @_;
#
#		require Lexi::Transport;
#
#		my $log = join "\n", $self->all_record_logs;
#
#		my $log_file = Lexi::Moose->_schema->resultset("File")->from_string(
#			$log,
#			{
#				name            => "log.txt",
#				file_type_value => "log"
#			}
#		);
#
#		my $transport = Lexi::Transport->new( transport_destination_id => $args{transport_destination_id} );
#		$transport->send( file => $log_file );
#	}

#	sub db_trace {
#
#		my $self = shift;
#		my %args = @_;
#
#		my $start = $args{start} // 1;
#		my $level = $args{level} // 1;
#
#		if ( $self->_show_debug($level) ) {
#			Lexi::Moose->_schema->storage->debug( $start ? 1 : 0 );
#		}
#	}

	__PACKAGE__->meta->make_immutable;

	1;
}

1;
