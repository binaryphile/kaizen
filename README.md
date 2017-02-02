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

Use the macros:

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
eval "$(importa shpec-helper import_functions)"

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

**`absolute_path <path>`** - normalize a path string

&emsp;Accepts a literal or a variable name

&emsp;*Returns*: normalized path on stdout

&emsp;The given path must exist.  It can be a directory or filename. \
&emsp;Returns the fully qualified path, without any relative path components \
&emsp;or double-slashes.

<dl>
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

<pre><code>myarray=()
defa myarray <<'EOS'
  Here are
  my lines.
EOS</code></pre>
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

<pre><code>mystring=''
defs mystring <<'EOS'
  Here are
  my lines.
EOS</code></pre>
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

<pre><code>myarray=()
geta myarray <<'EOS'
  Here are
  my lines.
EOS</code></pre>
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

<dt><code>is_executable_file &lt;path&gt;</code> - determines whether a
path is a file and has the executable permission</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: boolean true if <code>path</code> is a file with
the executable permission, or a symlink to one</p>

<p>Equivalent to <code>is_file path && is_executable path</code></p>
</dd>

<dt><code>is_file &lt;path&gt;</code> - determines whether a path is a
file</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: boolean true if <code>path</code> is a file
permission, or a symlink to one</p>

<p>Has the same semantics as the <code>[[ -f ]]</code> test</p>
</dd>

<dt><code>is_given &lt;variable_name&gt;</code> - determines whether the
named variable is not empty</dt>

<dd>
<p><em>Returns</em>: boolean false if <code>variable_name</code> is a
blank string, if a string variable, or has elements, if an array or
associative array.  Also returns false if <code>variable_name</code> is
not set.</p>

<p>Has the same semantics as the <code>[[ -n ]]</code> test</p>
</dd>

<dt><code>is_nonexecutable_file &lt;path&gt;</code> - determines whether
a path is a file and does not have the executable permission</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: boolean true if <code>path</code> is a file with
the executable permission, or a symlink to one</p>

<p>Equivalent to <code>is_file path && is_executable path</code></p>
</dd>

<dt><code>is_same_as &lt;string_1&gt; &lt;string_2&gt;</code> -
determines whether two strings are the same</dt>

<dd>
<p>Accepts literals or variable names</p>

<p><em>Returns</em>: boolean true if <code>string_1</code> and
<code>string_2</code> are exactly the same</p>
</dd>

<dt><code>is_set &lt;variable_name&gt;</code> - determines whether
<code>variable_name</code> is set to anything (including an empty string
or array)</dt>

<dd>
<p><em>Returns</em>: boolean true if <code>variable_name</code> has been
set</p>

<p>Has the same semantics as <code>declare -p <variable_name></code></p>
</dd>

<dt><code>is_symlink &lt;path&gt;</code> - determines whether
<code>path</code> is a symbolic link</dt>

<dd>
<p><em>Returns</em>: boolean true if <code>path</code> is a symbolic
link</p>

<p>Has the same semantics as the <code>[[ -h ]]</code> test</p>
</dd>

<dt><code>joina &lt;delimiter&gt; &lt;array&gt;</code> - joins an array
of variables, with the delimiter, into a string</dt>

<dd>
<p>Accepts literals or variable names</p>

<p><em>Returns</em>: the joined string on stdout</p>

<p><code>delimiter</code> must be a single character</p>
</dd>

<dt><code>puts &lt;message&gt;</code> - output a newline-terminated
string on stdout</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: the <code>message</code> string and a newline on
stdout</p>

<p>Meant as a substitute for the <code>echo</code> command.  Provides a
more consistent output mechanism than <code>echo</code> (try
<code>echo</code>ing "-n", for example).  <a
href=http://www.in-ulm.de/~mascheck/various/echo+printf/>Recommended
reading</a> on why <code>echo</code> can be an issue.</p> </dd>

<dt><code>putserr &lt;message&gt;</code> - output a newline-terminated
string on stderr</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: the <code>message</code> string and a newline on
stderr</p>
</dd>

<dt><code>putserr &lt;message&gt;</code> - output a newline-terminated
string on stderr</dt>

<dd>
<p>Accepts a literal or variable name</p>

<p><em>Returns</em>: the <code>message</code> string and a newline on
stderr</p>
</dd>
</dl>

[sorta]: https://github.com/binaryphile/sorta
[Aaron Maxwell]: http://redsymbol.net/articles/unofficial-bash-strict-mode/
[shpec]: https://github.com/rylnd/shpec
