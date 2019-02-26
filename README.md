[![Build Status](https://travis-ci.com/JJ/perl6-test-script-output.svg?branch=master)](https://travis-ci.com/JJ/perl6-test-script-output)

NAME
====

Test::Script::Output - blah blah blah

SYNOPSIS
========

    use Test::Script::Output;

    # in the tested file, file.p6
    say "Hello";

      Hello

    # in test
    output-ok( "file.p6", "script runs OK")

DESCRIPTION
===========

Test::Script::Output tests the output of scripts. In order to check it, every script must include an `=output` pod section with the output that should be expected from it.

Methods
=======

output-ok( $file, $msg)
-----------------------

The file can be either the name of an existing file, or a IO handle for that same file; the `$msg` is the test message.

dir-ok( $dir, $msg)
-------------------

Takes the files with the extension "*.p6" from a dir, and tests them, the test will be OK if all of the files check out.

AUTHOR
======

JJ Merelo <jjmerelo@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

