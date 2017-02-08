kaizen
======

In the spirit of small, continuous improvements of its namesake, kaizen
is a library of functions meant to be small improvements to working with
Bash (hereafter, "bash").

Features:

-   pure bash - no non-builtin commands or calls (macros discussed below
    are a separate library)

-   readability - many cryptic bashisms are given simple names, for
    example `is_given` for `[[ -n ]]`

-   some basic string operations - such as `to_upper` and `starts_with`

-   most functions accept variable names as arguments thanks to the
    [sorta] library

-   compatible with `sorta`'s import capabilities, which allows you to
    source only the functions you want rather than the entire library

-   the good parts of `strict_mode` (set -euo pipefail), as outlined by
    [Aaron Maxwell]

-   macros (actually global variables) for the safest forms of dangerous
    commands such as `rm -rf`, to make it easy to use them consistently

-   a shpec helper library is included, useful if you are a user of
    [shpec]

Installation
============

First clone [sorta] and add its `lib` to your PATH.

Then clone this repository and add its `lib` directory to your PATH.

Usage
=====

The whole library:

    source kzn.bash

Just the `is_given` and `to_upper` functions:

    source import.bash
    import_functions=(
      is_given
      to_upper
    )
    eval "$(importa kzn import_functions)"

Use the macros:

    source macros.bash

    $rm myfile

Use some of the shpec-helper functions:

    source import.bash
    import_functions=(
      cleanup
      initialize_shpec_helper
      shpec_source
    )
    eval "$(importa shpec-helper import_functions)"

    shpec_source lib/mylib.bash

Kaizen API
==========

"Accepts literals or variable names" means that the arguments may be
specified normally, using string literals or expansions for example, or
with the bare name of a variable (as a normal string argument). If the
receiving function detects that the supplied argument is the name of a
defined variable, it will automatically expand the variable itself.

Array and hash (associative array) literals may also be passed as
strings for those types of variables. Any literal that would work for
the right-hand-side of an assignment statement works in that case, such
as `'( [one]=1 [two]=2 )'` (remember to use single- or double-quotes).

- **`absolute_path <path>`** - normalize a path string

    Accepts a literal or a variable name

    *Returns*: normalized path on stdout

    The given path must exist. It can be a directory or filename.
    Returns the fully qualified path, without any relative path
    components or double-slashes.

- **`basename <path>`** - pure bash implementation of the basename
  command

    Accepts a literal or a variable name

    *Returns*: the final component of the path on stdout

    The path does not have to exist. It can be a directory or filename.
    Returns the portion of the path after the final slash.

- **`defa <variable name>`** - read and un-indent a string from stdin
  and split lines into the named array variable

    *Returns*: nothing. Creates or sets the named array variable as a
    side-effect. If you want to scope the variable locally, it must
    already be declared. Any contents will be replaced. Sets the
    variable to an array of the lines read from stdin.

    The lines are de-indented by the amount of whitespace indentation of
    the first line. Blank lines (even without indentation) are
    preserved.

    Usually fed with a heredoc, such as:

        myarray=()
        defa myarray <<'EOS'
          Here are
          my lines.
        EOS

- **`defs <variable_name>`** - read and un-indent a string from stdin
  into the named string variable

    *Returns*: nothing. Creates or sets the named string variable as a
    side-effect. If you want to scope the variable locally, it must
    already be declared. Any contents will be replaced.  Sets the
    variable to the lines read from stdin, including newlines.

    The lines are de-indented by the amount of whitespace indentation of
    the first line. Blank lines (even without indentation) are
    preserved.

    Usually fed with a heredoc, such as:

        mystring=''
        defs mystring <<'EOS'
          Here are
          my lines.
        EOS

- **`dirname <path>`** - pure bash implementation of the dirname command

    Accepts a literal or a variable name

    *Returns*: the path argument without its final component on stdout

    The path does not have to exist. It can be a directory or filename.
    Returns the portion of the path before the final slash.  If
    there are no slashes in `path`, returns ".".

- **`errexit <message> [return_code]`** - print `message` on stderr and
  exit with optional return code

    Accepts literals or variable names

    `return_code` defaults to 1

- **`geta <variable_name>`** - read a string from stdin and split lines
  into the named array variable

    *Returns*: nothing. Creates or sets the named array variable as a
    side-effect. If you want to scope the variable locally, it must
    already be declared. Any contents will be replaced. Sets the
    variable to an array of the lines read from stdin.

    Blank lines are preserved.

    Usually fed with a heredoc, such as:

        myarray=()
        geta myarray <<'EOS'
          Here are
          my lines.
        EOS

- **`has_length <length> <array>`** - determines whether an array is of
  the named length

    Accepts literals or variable names

    *Returns*: boolean true if `array` has `length` number of items,
    false otherwise

- **`is_directory <path>`** - determines whether a path is an actual
  directory

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a directory or symlink to a
    directory

    Has the same semantics as the `[[ -d ]]` test

- **`is_executable <path>`** - determines whether a path is executable

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file or directory with the
    executable permission, or a symlink to one

    Has the same semantics as the `[[ -x ]]` test

- **`is_executable_file <path>`** - determines whether a path is a file
  and has the executable permission

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file with the executable
    permission, or a symlink to one

    Equivalent to `is_file path && is_executable path`

- **`is_file <path>`** - determines whether a path is a file

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file permission, or a symlink
    to one

    Has the same semantics as the `[[ -f ]]` test

- **`is_given <variable_name>`** - determines whether the named variable
  is not empty

    *Returns*: boolean false if `variable_name` is a blank string, if a
    string variable, or has elements, if an array or associative
    array. Also returns false if `variable_name` is not set.

    Has the same semantics as the `[[ -n ]]` test

- **`is_nonexecutable_file <path>`** - determines whether a path is a
  file and does not have the executable permission

    Accepts a literal or variable name

    *Returns*: boolean true if `path` is a file with the executable
    permission, or a symlink to one

    Equivalent to `is_file path && is_executable path`

- **`is_same_as <string_1> <string_2>`** - determines whether two
  strings are the same

    Accepts literals or variable names

    *Returns*: boolean true if `string_1` and `string_2` are exactly the
    same

- **`is_set <variable_name>`** - determines whether `variable_name` is
  set to anything (including an empty string or array)

    *Returns*: boolean true if `variable_name` has been set

    Has the same semantics as `declare -p <variable_name>`

- **`is_symlink <path>`** - determines whether `path` is a symbolic link

    *Returns*: boolean true if `path` is a symbolic link

    Has the same semantics as the `[[ -h ]]` test

- **`joina <delimiter> <array>`** - joins an array of variables, with
  the delimiter, into a string

    Accepts literals or variable names

    *Returns*: the joined string on stdout

    `delimiter` must be a single character

- **`puts <message>`** - output a newline-terminated string on stdout

    Accepts a literal or variable name

    *Returns*: the `message` string and a newline on stdout

    Meant as a substitute for the `echo` command. Provides a more
    consistent output mechanism than `echo` (try `echo`ing     "-n", for
    example). [Recommended reading] on why `echo` can be an issue.

- **`putserr <message>`** - output a newline-terminated string on stderr

    Accepts a literal or variable name

    *Returns*: the `message` string and a newline on stderr

- **`splits <delimiter> <string> <array_name>`** - split a string on a
  delimiter

    Accepts literals or variable names except for `array_name`

    *Returns*: the split elements in the named array

    Only works with single-character delimiters.  The return array must
    be declared prior to invocation and should be empty.  Setting the
    return value is a side-effect.

- **`starts_with <prefix> <string>`** - test if the string starts with
  the prefix

    Accepts literals or variable names

    *Returns*: true or false

    `prefix` may be a single character or string.

- **`strict_mode <status>`** - enable or disable bash strict mode

    Accepts a literals or variable name

    *Returns*: nothing

    `status` can be `on` or `off`.

    Strict mode is the three shell options "errexit", "nounset" and
    "pipefail".  Together they tell bash to be more aggressive     about
    stopping upon unexpected error conditions.  Read more about it from
    [Aaron Maxwell] and [David Pashley].

    Also read all the reasons why [you shouldn't use it].  Then realize
    how stupid they are and use it anyway.  But *don't expect any help
    with it*.  It won't always work.  Don't depend on it, just
    appreciate it when it stops your script from puking all over itself,
    without having had to write perfect error-handling code on *every
    line* (like any other sane language).

stripa

to\_lower

to\_upper

  [sorta]: https://github.com/binaryphile/sorta
  [Aaron Maxwell]: http://redsymbol.net/articles/unofficial-bash-strict-mode/
  [shpec]: https://github.com/rylnd/shpec
  [Recommended reading]: http://www.in-ulm.de/~mascheck/various/echo+printf
  [David Pashley]: http://www.davidpashley.com/articles/writing-robust-shell-scripts/
  [you shouldn't use it]: http://mywiki.wooledge.org/BashFAQ/105
