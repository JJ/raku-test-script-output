[![Build Status](https://travis-ci.com/JJ/perl6-test-script-output.svg?branch=master)](https://travis-ci.com/JJ/perl6-test-script-output)

NAME
====

Test::Script::Output - Tests the output of scripts with special comments

SYNOPSIS
========

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

DESCRIPTION
===========

`Test::Script::Output` tests the output of scripts. In order to check it, every script must include an `=output` pod section with the output that should be expected from it.

You can either set the output explicitly

    =output
    First line
    Second line

Or match the whole output via a regex, which can be used when the output is variable

    =output
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

