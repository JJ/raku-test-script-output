use v6.c;
unit module Test::Script::Output:ver<0.0.5>;

use IO::Capture::Simple;
use Pod::Load;
use Test;

sub output-ok( $f, Str $msg ) is export {

    my ($output, $wanted-output) = _get_outputs( $f );
    if !$wanted-output {
        ok( $output, $msg );
    } elsif $wanted-output ~~ /^^\// { #Treat as regular expression
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
	    for dir($dir, test => /\.p6 | \.raku $$/ ) -> $f {
            say "f is $f";
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
        say "Output de $f : $output\n", @pod;
        for @pod -> $block {
            $wanted-output ~= $block.contents.join("");
        }
        $output ~~ s/Pod"::"Load"::"m\d+"::"//;

        CATCH {
            say .message;
        }
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

C<Test::Script::Output> tests the output of scripts. Desired output  must be
included aas an C<=output> pod section with the literal
output that should be expected from it. If that changes, a regular expression can be used.

You can either set the output explicitly

    =output
    First line
    Second line

Or match the whole output via a regex,
which can be used when the output is variable

    =output
    /^^ Start /

The scripts can include external compunits as long as they're available, and you
take care of including all relevant paths via C<use lib>.

If you want to check out how this works, the biggest collection of examples is
at L<https://github.com/JJ/perl6-quick-reference-apress>.

Provided is also a C<Dockerfile> you can use directly for your tests; check it
out at L<https://cloud.docker.com/repository/docker/jjmerelo/perl6-test-script-output/>

Use this CI workflow for testing your scripts (or something like that,
changing the name of the directory).

=begin code
language: minimal

services:
  - docker

install:
  - docker pull jjmerelo/perl6-test-script-output
  - mkdir t && echo "use Test::Script::Output;for <Chapter7 Chapter8 Chapter9 Chapter10> -> \$d { dir-ok( \$d.IO , 'Scripts in dir ' ~ \$d ~ ' are OK') }" > t/0.t

script: docker run -t -v  $TRAVIS_BUILD_DIR:/test jjmerelo/perl6-test-script-output
=end code

=head1 Methods

=head2 output-ok( $file, $msg)

The argument can be either the name of an existing file,
or a IO handle for that same file; the C<$msg> is the test message.

=head2 dir-ok( $dir, $msg)

Takes the files with the extension `*.p6` and `*.raku` from a dir, and tests
them, the test will be OK if all of the files check out.

=head2 _get_output( $f )

This is the (private) routine doing the real work of extracting the expected
and actual output from the file. It's not exported by default.

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 Note

This test module was created originally to test the scripts for the
book "Perl 6 Quick Reference", which is due to be published later
this year by Apress.

=head1 COPYRIGHT AND LICENSE

Copyright 2019,2022 JJ Merelo

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod
