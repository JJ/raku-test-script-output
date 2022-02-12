use v6;
use Test;
use Test::Script::Output;

plan 1;

my $f = "gather.raku";
my $io = "./$f".IO.e ?? "./$f".IO !! "t/$f".IO;
output-ok( $io, "$f output is OK" );


