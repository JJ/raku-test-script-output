[![Build Status](https://travis-ci.org/JJ/perl6-test-script-output.svg?branch=master)](https://travis-ci.org/JJ/perl6-test-script-output)

NAME
====

Test::Script::Output - Tests the output of scripts using special comments

SYNOPSIS
========

    use Test::Script::Output;

    # in the tested file, file.p6
    say "Hello";

      Hello

    # in test
    output-ok( "file.p6", "script runs OK")

    # Another tested file, regex.p6
    say "Time now is ", now;

      /^^Time now/

    # in test
    output-ok( "regex.p6", "script tested via regex runs OK")

DESCRIPTION
===========

`Test::Script::Output` tests the output of scripts. Desired output must be included aas an `=output` pod section with the literal output that should be expected from it. If that changes, a regular expression can be used.

You can either set the output explicitly

        First line
        Second line

Or match the whole output via a regex, which can be used when the output is variable

        /^^ Start /

Methods
=======

output-ok( $file, $msg)
-----------------------

The argument can be either the name of an existing file, or a IO handle for that same file; the `$msg` is the test message.

dir-ok( $dir, $msg)
-------------------

Takes the files with the extension "*.p6" from a dir, and tests them, the test will be OK if all of the files check out.

AUTHOR
======

JJ Merelo <jjmerelo@gmail.com>

Note
====

This test module was created originally to test the scripts for the book "Perl 6 Quick Reference", which is due to be published later this year by Apress.

COPYRIGHT AND LICENSE
=====================

Copyright 2019 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

