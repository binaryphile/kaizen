kaizen [![Build Status](https://travis-ci.org/binaryphile/kaizen.svg?branch=master)](https://travis-ci.org/binaryphile/kaizen)
======

In the spirit of small, continuous improvements of its namesake, kaizen
is a library of functions meant to be small improvements to working with
bash.

Features:

-   readability - many cryptic bashisms are given simple names, for
    example `given?` for `[[ -n ]]`

**NOTE: This readme is mostly correct but out of date. I will update it
as soon as possible. In the meantime, inspect the tests in `shpec/` for
usage.**

Installation
============

First clone [concorde] and add it's `lib` directory to your path.

Then clone this repository and add its `lib` directory to your path.

Usage
=====

This library is built on the functionality in `concorde`, so please
consult its documentation first.

The whole library:

    source concorde.bash
    $(require kaizen)

Just the `given?` function:

    source concorde.bash
    $(bring given? from kaizen)

Kaizen API
==========

"Accepts literals or variable names" means that the arguments may be
specified normally, using string literals or expansions for example, or
with the bare name of a variable (as a normal string argument). If the
receiving function detects that the supplied argument is the name of a
defined variable, it will automatically expand the variable itself.

Array and hash (associative array) literals may also be passed as
strings for those types of variables. Any literal that would work for
the right-hand-side of an assignment statement works (minus parentheses
and identifier brackets) in that case, such as `'one=1 two=2'`
(remember to use single- or double-quotes).

-   append\_to\_file

-   args?

-   contains?

-   **`directory?`** *`path`* - determines whether a path is an actual
    directory

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a directory or symlink to a
    directory

    Has the same semantics as the `[[ -d ]]` test

-   ends\_with?

-   **`executable?`** *`path`* - determines whether a path is executable

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file or directory with the
    executable permission, or a symlink to one

    Has the same semantics as the `[[ -x ]]` test

-   **`executable_file?`** *`path`* - determines whether a path is a
    file and has the executable permission

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file with the executable
    permission, or a symlink to one

    Equivalent to `file? path && executable? path`

-   false?

-   **`file?`** *`path`* - determines whether a path is a file

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file permission, or a symlink
    to one

    Has the same semantics as the `[[ -f ]]` test

-   **`given?`** *`variable_name`* - determines whether the named
    variable is not empty

    *Returns*: boolean false if `variable_name` is a blank string, if a
    string variable, or has elements, if an array or associative array.
    Also returns false if `variable_name` is not set.

    Has the same semantics as the `[[ -n ]]` test

-   glob?

-   less\_than?

-   more\_than?

-   **`nonexecutable_file?`** *`path`* - determines whether a path is a
    file and does not have the executable permission

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file with the executable
    permission, or a symlink to one

    Equivalent to `file? path && executable? path`

-   trim\_from\_last

-   trim\_from\_last

-   true?

-   write\_to\_file

  [concorde]: https://github.com/binaryphile/concorde
