[![Test-install and cache deps](https://github.com/JJ/raku-test-script-output/actions/workflows/test.yaml/badge.svg)](https://github.com/JJ/raku-test-script-output/actions/workflows/test.yaml)

NAME
====

Test::Script::Output - Tests the output of scripts using special comments

SYNOPSIS
========

```raku
# in the tested file, file.p6
say "Hello";
=output
Hello
```

The test file for this will be:

```raku
use Test::Script::Output;
output-ok( "file.p6", "script runs OK")
```

In another file:

```raku
# Another tested file, regex.p6
say "Time now is ", now;
=output
/^^Time now/
```

Can be tested with:

```
output-ok( "regex.p6", "script tested via regex runs OK")
```

DESCRIPTION
===========

`Test::Script::Output` tests the output of scripts. Desired output must be included aas an `=output` pod section with the literal output that should be expected from it. If that changes, a regular expression can be used.

You can either set the output explicitly

```raku
=output
First line
Second line
```

Or match the whole output via a regex, which can be used when the output is variable

```raku
=output
/^^ Start /
```


The scripts can include external compunits as long as they're available, and you take care of including all relevant paths via `use lib`.

If you want to check out how this works, the biggest collection of examples is at [https://github.com/JJ/perl6-quick-reference-apress](https://github.com/JJ/perl6-quick-reference-apress).

Provided is also a Dockerfile you can use directly for your tests; check it out at [https://cloud.docker.com/repository/docker/jjmerelo/perl6-test-script-output/](https://cloud.docker.com/repository/docker/jjmerelo/perl6-test-script-output/)

Use this `.travis.yml` for testing your scripts (or something like that, changing the name of the directory)

    language: minimal

    services:
      - docker

    install:
      - docker pull jjmerelo/perl6-test-script-output
      - mkdir t && echo "use Test::Script::Output;for <Chapter7 Chapter8 Chapter9 Chapter10> -> \$d { dir-ok( \$d.IO , 'Scripts in dir ' ~ \$d ~ ' are OK') }" > t/0.t

    script: docker run -t -v  $TRAVIS_BUILD_DIR:/test jjmerelo/perl6-test-script-output

Methods
=======

output-ok( $file, $msg)
-----------------------

The argument can be either the name of an existing file, or a IO handle for that same file; the `$msg` is the test message.

dir-ok( $dir, $msg)
-------------------

Takes the files with the extension "*.p6" from a dir, and tests them, the test will be OK if all of the files check out.

_get_output( $f )
-----------------

This is the routine doing the real work of extracting the expected and actual output from the file. It's not exported by default.

AUTHOR
======

JJ Merelo <jjmerelo@gmail.com>

Note
====

This test module was created originally to test the scripts for the book
 ["Perl 6 Quick Reference"](https://link.springer.com/book/10.1007/978-1-4842
 -4956-7), published by Apress.

COPYRIGHT AND LICENSE
=====================

Copyright 2019 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

