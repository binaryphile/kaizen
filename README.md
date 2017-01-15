# kaizen

In the spirit of small, continuous improvements of its namesake, kaizen
is a library of functions meant to be small improvements to working with
Bash (hereafter, "bash").

Features:

- pure bash - no non-builtin commands or calls (macros discussed below
  are a separate library)

- readability - many cryptic bashisms are given simple names, for
  example `is_given` for `[[ -n ]]`

- some basic string operations - such as `to_upper` and `starts_with`

- most functions accept variable names as arguments thanks to the
  [sorta] library

- compatible with `sorta`'s import capabilities, which allows you to
  source only the functions you want rather than the entire library

- the good parts of `strict_mode` (set -euo pipefail), as outlined by
  [Aaron Maxwell]

- macros (actually global variables) for the safest forms of dangerous
  commands such as `rm -rf`, to make it easy to use them consistently

- a shpec helper library is included, useful if you are a user of
  [shpec]

# Installation

Clone this repository and add its `lib` directory to your PATH in
`.bash_profile` or another suitable rc file.

# Usage

The whole library:

```
source kzn.bash
```

Just the `is_given` and `to_upper` functions:

```
source import.bash
import_functions=(
  is_given
  to_upper
)
eval "$(importa kzn import_functions)"
```

Use the macros (sourced, not imported):

```
source macros.bash

$rm myfile
```

Use some of the shpec-helper functions:

```
source import.bash
import_functions=(
  cleanup
  initialize_shpec_helper
  shpec_source
)
eval "$(importa kzn import_functions)"

shpec_source lib/mylib.bash
```

# Kaizen Functions

- **`absolute_path <path>`** - normalize a path string

    Accepts a literal or a variable name.

    *Returns*: normalized path on stdout

    The given path must exist.  It can be a directory or filename.
    Returns the fully qualified path, without any relative path
    components or double-slashes.

- **`basename <path>`** - pure bash implementation of the basename
  command

    Accepts a literal or a variable name

    *Returns*: the final component of the path on stdout

    The path does not have to exist.  It can be a directory or filename.
    Returns the portion of the path after the final slash.

- **`defa <variable name>`** - read an indented heredoc string from
  stdin into an array

    *Returns*: nothing.  Creates or sets the named array variable as a
    side-effect.  Sets it to an array of the lines read from stdin.

    The lines are de-indented by the amount of indentation of the first
    line.  Blank lines (even without indentation) are preserved.

    Usually fed with a heredoc, such as:

        defa myarray «'EOS'
          Here are
          my lines.
        EOS


[sorta]: https://github.com/binaryphile/sorta
[Aaron Maxwell]: http://redsymbol.net/articles/unofficial-bash-strict-mode/
[shpec]: https://github.com/rylnd/shpec
