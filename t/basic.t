use strict;
use warnings;
use Test::More;

use lib 't/lib';
use MLTests;

my $str = <<'END_STR';
x = 1
y = 1
x = 10
z = 2
x = 2
END_STR

is_deeply(
  MLTests->read_string($str),
  { x => 13, y => 1, z => 2 },
  "read_string",
);

is_deeply(
  MLTests->read_string_sub($str),
  { x => -13, y => -1, z => -2 },
  "read_string_sub",
);

is_deeply(
  MLTests->read_string_mul($str),
  { x => 20, y => 1, z => 2 },
  "read_string_mul",
);

done_testing;
