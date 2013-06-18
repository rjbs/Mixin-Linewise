use strict;
use warnings;
package Mixin::Linewise;
# ABSTRACT: write your linewise code for handles; this does the rest
use 5.006;
use Carp ();
Carp::confess "not meant to be loaded";

=head1 DESCRIPTION

It's boring to deal with opening files for IO, converting strings to
handle-like objects, and all that.  With L<Mixin::Linewise::Readers> and
L<Mixin::Linewise::Writers>, you can just write a method to handle handles, and
methods for handling strings and filenames are added for you.

=cut

1;
