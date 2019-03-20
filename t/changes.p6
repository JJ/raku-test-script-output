#!/usr/bin/env perl6

use v6;

my $now = now;
say "Takes ", now - $now;

=output
/^^Takes \s+/
