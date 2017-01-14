# kaizen

In the spirit of small, continuous improvements of its namesake, Kaizen
(hereafter, "kaizen") is a library of functions meant to be small
improvements to working with Bash (hereafter, "bash").

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

- automatic use of alternate BSD forms of macros for MacOS

[sorta]: https://github.com/binaryphile/sorta
[Aaron Maxwell]: http://redsymbol.net/articles/unofficial-bash-strict-mode/
