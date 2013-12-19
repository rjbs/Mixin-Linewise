use strict;
use warnings;
use Test::More 0.88;

use utf8;
use lib 't/lib';
use MLTests;
use Encode qw/encode_utf8/;

my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";

my $name = "®icardo Sígnes";
my $raw = encode_utf8($name);

{
  package WriterTester;
  use Mixin::Linewise::Writers -writers;

  sub write_handle {
    my ($self, $data, $handle) = @_;
    print {$handle} $data;
  }
}

my $output = WriterTester->write_string($name);
is($output, $raw, "wrote a character string and got an octet string");

done_testing;
# vim: ts=2 sts=2 sw=2 et:
