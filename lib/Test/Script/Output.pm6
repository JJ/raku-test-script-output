use v6.c;
unit class Test::Script::Output:ver<0.0.1>;

use IO::Capture::Simple;
use Pod::Load;
use Test;

sub output-ok( $f, Str $msg ) is export {
    my @pod;
    my $output = capture_stdout {
        @pod = load( $f );
    };
    my $real-output;
    for @pod -> $block {
        say $block.contents;
        $real-output ~= $block.contents.join("");
    }
    if $real-output ~~ /^^\// { #Treat as regular expression
        $real-output ~~ /^^\/$<regex>= [ .+ ]\//;
        my $extracted = ~$<regex>;
        like( $output, / <$extracted> /, $msg );
    } else {
        is( $output, $real-output, $msg );
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


=begin pod

=head1 NAME

Test::Script::Output - blah blah blah

=head1 SYNOPSIS

  use Test::Script::Output;

  # in the tested file, file.p6
  say "Hello";
  =output
  Hello

  # in test
  output-ok( "file.p6", "script runs OK")

  
=head1 DESCRIPTION

Test::Script::Output tests the output of scripts. In order to check it, every script must include an C<=output> pod section with the output that should be expected from it.
									      
=head1 Methods

=head2 output-ok( $file, $msg)

The file can be either the name of an existing file, or a IO handle for that same file; the C<$msg> is the test message.




=head2 dir-ok( $dir, $msg)

Takes the files with the extension "*.p6" from a dir, and tests them, the test will be OK if all of the files check out.

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
