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

# Kaizen API

"Accepts literals or variable names" means that the arguments may be
specified normally, using string literals or expansions for example, or
with the bare name of a variable (as a normal string argument).  If the
receiving function detects that the supplied argument is the name of a
defined variable, it will automatically expand the variable itself.

Array and hash (associative array) literals may also be passed as
strings for those types of variables.  Any literal that would work for
the right-hand-side of an assignment statement works in that case, such
as `'( [one]=1 [two]=2 )'` (remember to use single- or double-quotes).

<dl>
<dt><code>absolute_path &lt;path&gt;</code> - normalize a path
string</dt>

<dd>
<p>Accepts a literal or a variable name</p>

<p><em>Returns</em>: normalized path on stdout</p>

<p>The given path must exist.  It can be a directory or filename.
Returns the fully qualified path, without any relative path components
or double-slashes.</p>
</dd>

<dt><code>basename &lt;path&gt;</code> - pure bash implementation of the
basename command</dt>

<dd>
<p>Accepts a literal or a variable name</p>

<p><em>Returns</em>: the final component of the path on stdout</p>

<p>The path does not have to exist.  It can be a directory or filename.
Returns the portion of the path after the final slash.</p>
</dd>

<dt><code>defa &lt;variable name&gt;</code> - read and un-indent a
string from stdin and split lines into the named array variable</dt>

<dd>
<p><em>Returns</em>: nothing.  Creates or sets the named array
variable as a side-effect.  If you want to scope the variable locally,
it must already be declared.  Any contents will be replaced.  Sets the
variable to an array of the lines read from stdin.</p>

<p>The lines are de-indented by the amount of whitespace indentation of
the first line.  Blank lines (even without indentation) are
preserved.</p>

<p>Usually fed with a heredoc, such as:</p>

<pre><code>
myarray=()
defa myarray <<'EOS'
  Here are
  my lines.
EOS
</code></pre>
</dd>

<dt><code>defs &lt;variable_name&gt;</code> - read and un-indent a
string from stdin into the named string variable</dt>

<dd>
<p><em>Returns</em>: nothing.  Creates or sets the named string variable
as a side-effect.  If you want to scope the variable locally, it must
already be declared.  Any contents will be replaced.  Sets the variable
to the lines read from stdin, including newlines.</p>

<p>The lines are de-indented by the amount of whitespace indentation of
the first line.  Blank lines (even without indentation) are
preserved.</p>

<p>Usually fed with a heredoc, such as:</p>

<pre><code>
mystring=''
defs mystring <<'EOS'
  Here are
  my lines.
EOS
</code></pre>
</dd>

<dt><code>dirname &lt;path&gt;</code> - pure bash implementation of the
dirname command</dt>

<dd>
<p>Accepts a literal or a variable name</p>

<p><em>Returns</em>: the path argument without its final component on
stdout</p>

<p>The path does not have to exist.  It can be a directory or filename.
Returns the portion of the path before the final slash.  If there are no
slashes in <code>path</code>, returns ".".</p>
</dd>

<dt><code>errexit &lt;message&gt; [return_code]</code> - print
<code>message</code> on stderr and exit with optional return code</dt>

<dd>
<p>Accepts literals or variable names</p>

<p><code>return_code</code> defaults to 1</p>
</dd>

<dt><code>geta &lt;variable_name&gt;</code> - read a string from stdin
and split lines into the named array variable</dt>

<dd>
<p><em>Returns</em>: nothing.  Creates or sets the named array variable
as a side-effect.  If you want to scope the variable locally, it must
already be declared.  Any contents will be replaced.  Sets the variable
to an array of the lines read from stdin.</p>

<p>Blank lines are preserved.</p>

<p>Usually fed with a heredoc, such as:</p>

<pre><code>
myarray=()
geta myarray <<'EOS'
  Here are
  my lines.
EOS
</code></pre>
</dd>

<dt><code>has_length &lt;length&gt; &lt;array&gt;</code> - determines
whether an array is of the named length</dt>

<dd>
<p>Accepts literals or variable names</p>

<p><em>Returns</em>: boolean true if <code>array</code> has
<code>length</code> number of items, false otherwise</p>
</dd>

<dt><code>is_directory &lt;path&gt;</code> - determines whether a path
is an actual directory</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: boolean true if <code>path</code> is a directory or
symlink to a directory</p>

<p>Has the same semantics as the <code>[[ -d ]]</code> test</p>
</dd>

<dt><code>is_executable &lt;path&gt;</code> - determines whether a path
has the executable permission</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: boolean true if <code>path</code> is a file or
directory with the executable permission, or a symlink to one</p>

<p>Has the same semantics as the <code>[[ -x ]]</code> test</p>
</dd>

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
  string variable, or has elements, if an array or associative array.
  Also returns false if `variable_name` is not set.

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

  Meant as a substitute for the `echo` command.  Provides a more
  consistent output mechanism than `echo` (try `echo`ing "-n", for
  example).  [Recommended reading] on why `echo` can be an issue.

- **`putserr <message>`** - output a newline-terminated string on stderr

  Accepts a literal or variable name

  *Returns*: the `message` string and a newline on stderr

- **`putserr <message>`** - output a newline-terminated string on stderr

  Accepts a literal or variable name

  *Returns*: the `message` string and a newline on stderr

[sorta]: https://github.com/binaryphile/sorta
[Aaron Maxwell]: http://redsymbol.net/articles/unofficial-bash-strict-mode/
[shpec]: https://github.com/rylnd/shpec
[Recommended reading]: http://www.in-ulm.de/~mascheck/various/echo+printf/
