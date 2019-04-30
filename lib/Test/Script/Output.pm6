use v6.c;
unit class Test::Script::Output:ver<0.0.3.3>;

use IO::Capture::Simple;
use Pod::Load;
use Test;

sub output-ok( $f, Str $msg ) is export {

    my ($output, $wanted-output) = _get_outputs( $f );
    
    if $wanted-output ~~ /^^\// { #Treat as regular expression
        $wanted-output ~~ /^^\/$<regex>= [ .+ ]\//;
        my $extracted = ~$<regex>;
        like( $output, / <$extracted> /, $msg );
    } else {
        is( $output, $wanted-output, $msg );
    }
}

sub dir-ok( $dir, Str $msg ) is export {
    fail "No such dir" if !$dir.d;
    subtest {
	for dir($dir, test => /\.p6 $$/ ) -> $f {
	    output-ok( $f.IO, "$f in dir is OK" );
	}
    }
}

sub _get_outputs( $f ) {
    my ($output, $wanted-output);
    try {
        my @pod;
        $output = capture_stdout {
            @pod = load( $f );
        };
        for @pod -> $block {
            $wanted-output ~= $block.contents.join("");
        }
        $output ~~ s/Pod"::"Load"::"m\d+"::"//;
    }

    if $! and $! ~~ X::Package::UseLib { # with `use lib` we need another strategy
        $wanted-output = $f.slurp.split("=output")[1];
        my ($dir) = $f.path.split("/")[0];
        $output = qqx{ perl6 -I$dir $f };
    }
    
    return $output, $wanted-output;
}


=begin pod

=head1 NAME

Test::Script::Output - Tests the output of scripts using special comments

=head1 SYNOPSIS

  use Test::Script::Output;

  # in the tested file, file.p6
  say "Hello";
  =output
  Hello

  # in test
  output-ok( "file.p6", "script runs OK")

  # Another tested file, regex.p6
  say "Time now is ", now;
  =output
  /^^Time now/


  # in test
  output-ok( "regex.p6", "script tested via regex runs OK")

=head1 DESCRIPTION

C<Test::Script::Output> tests the output of scripts. Desired output  must be included aas an C<=output> pod section with the literal
output that should be expected from it. If that changes, a regular expression can be used.

You can either set the output explicitly

    =output
    First line
    Second line

Or match the whole output via a regex,
which can be used when the output is variable

    =output
    /^^ Start /


=head1 Methods

=head2 output-ok( $file, $msg)

The argument can be either the name of an existing file,
or a IO handle for that same file; the C<$msg> is the test message.

=head2 dir-ok( $dir, $msg)

Takes the files with the extension "*.p6" from a dir, and tests them, the test will be OK if all of the files check out.

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 Note

This test module was created originally to test the scripts for the
book "Perl 6 Quick Reference", which is due to be published later
this year by Apress.


=head1 COPYRIGHT AND LICENSE

Copyright 2019 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
