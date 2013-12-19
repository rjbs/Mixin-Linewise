use strict;
use warnings;
use Test::More 0.88;

use lib 't/lib';
use MLTests;

my $str = <<'END_STR';
x = 1
y = 1
x = 10
z = 2
x = 2
END_STR

for my $pair (
  [ string => $str         ],
  [ file   => 't/data.txt' ],
  [ handle => sub {
      open my $fh, '<', 't/data.txt' or die "can't open test data"; $fh
    }
  ],
) {
  my $base = "read_$pair->[0]";
  my $arg  = ref $pair->[1] ? $pair->[1]->() : $pair->[1];
  is_deeply(
    MLTests->$base($arg),
    { x => 13, y => 1, z => 2 },
    $base,
  );

  my $sub = "read_$pair->[0]_sub";
     $arg = ref $pair->[1] ? $pair->[1]->() : $pair->[1];
  is_deeply(
    MLTests->$sub($arg),
    { x => -13, y => -1, z => -2 },
    $sub,
  );

  my $mul = "read_$pair->[0]_mul";
     $arg  = ref $pair->[1] ? $pair->[1]->() : $pair->[1];
  is_deeply(
    MLTests->$mul($arg),
    { x => 20, y => 1, z => 2 },
    $mul,
  );
}

my $utf8_str = <<'END_STR';
Queensrÿche = 10
Spin̈al Tap  = 20
END_STR

# Note that while the input string is octets, the keys below will be
# characters.  This is intentional.  read_string will have applied a utf-8
# decoding layer. -- rjbs, 2013-12-19
{
  use utf8; # <-- for the benefit of the hash keys
  is_deeply(
    MLTests->read_string($utf8_str),
    { 'Queensrÿche' => 10, 'Spin̈al Tap' => 20 },
    "read a UTF-8 encoded string",
  );
}

done_testing;
