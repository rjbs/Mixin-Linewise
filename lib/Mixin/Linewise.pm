use strict;
use warnings;
package Mixin::Linewise;

use Carp ();
use IO::File;
use IO::String;
use Params::Util qw(_CODELIKE);

use Sub::Exporter -setup => {
  exports => { map { "read_$_" => \"_mk_read_$_" } qw(file string handle) },
  groups  => { readers => [ qw(read_file read_string read_handle) ] },
};

sub _iterate_handle_method {
  my ($mixin, $handle, $invocant, $code) = @_;
  LINE: while (my $line = $handle->getline) {
    $invocant->$code($line, $handle);
  }
}

sub _iterate_handle_method {
  my ($mixin, $handle, $invocant, $method) = @_;
  LINE: while (my $line = $handle->getline) {
    $invocant->$method($line, $handle);
  }
}

=head2 read_file

  my $hash_ref = Config::INI::Reader->read($filename);

Given a filename, this method returns a hashref of the contents of that file.

=cut

sub _plan {
  my ($self, $arg) = @_;

  Carp::confess "both 'code' and 'method' provided"
    if $arg->{code} and $arg->{method};

  Carp::confess "neither 'code' nor 'method' provided"
    unless $arg->{code} or $arg->{method};

  if ($arg->{code}) {
    Carp::confess "invaild 'code' argument $arg->{code} given"
      unless _CODELIKE($arg->{code});

    return (_iterate_handle_code => $arg->{code});
  }

  return (_iterate_handle_method => "$arg->{method}");
}

sub _mk_read_file {
  my ($self, $name, $arg) = @_;
  my ($iter_method, $code) = $self->_plan($arg);

  sub {
    my ($invocant, $filename) = @_;

    # Check the file
    Carp::croak "no filename specified"           unless $filename;
    Carp::croak "file '$filename' does not exist" unless -e $filename;
    Carp::croak "'$filename' is not a plain file" unless -f _;

    my $handle = IO::File->new($filename, '<')
      or Carp::croak "couldn't read file '$filename': $!";

    $self->$iter_method($handle, $invocant, $code);
  }
}

=head2 read_string

  my $hash_ref = Config::INI::Reader->read_string($string);

Given a string, this method returns a hashref of the contents of that string.

=cut

# Create an object from a string
sub _mk_read_string {
  my ($self, $name, $arg) = @_;
  my ($iter_method, $code) = $self->_plan($arg);

  sub {
    my ($invocant, $string) = @_;

    Carp::croak "no string provided" unless defined $string;

    my $handle = IO::String->new($string);

    $self->$iter_method($handle, $invocant, $code);
  }
}

=head2 read_handle

  my $hash_ref = Config::INI::Reader->read_handle($io_handle);

Given an IO::Handle, this method returns a hashref of the contents of that
handle.

=cut

sub _mk_read_handle {
  my ($self, $name, $arg) = @_;
  my ($iter_method, $code) = $self->_plan($arg);

  sub {
    my ($invocant, $handle) = @_;
    $self->$iter_method($handle, $invocant, $code);
  };
}

=head1 BUGS

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Config-INI>

For other issues, or commercial enhancement or support, contact the author.

=head1 AUTHOR

Ricardo SIGNES, C<< E<lt>rjbs@cpan.orgE<gt> >>

Originaly derived from L<Config::Tiny>, by Adam Kennedy.

=head1 COPYRIGHT

Copyright 2007, Ricardo SIGNES.

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
