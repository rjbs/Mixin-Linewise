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

done_testing;
