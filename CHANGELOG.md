Change Log
==========

The format is based on [Keep a Changelog] and this project adheres to
[Semantic Versioning], with the minor exception that v10 is considered
v0 in semver parlance.

[Unreleased]
------------

### Changed

-   formatting of function declarations to match bash internal format

-   shpec test turns on stop_on_error before sourcing kaizen

-   stop_on_error turns on nounset and pipefail now

### Added

-   `shpec_cwd` is a macro (variable) meant to replace shpec_source, to
    prevent scoping issues with declarations (function context) when
    trying to use shpec_source function

-   `shpec_cleanup` is the new name for `cleanup`, which was too generic
    conflicted with other libraries under test

-   macros for install

### Fixed

-   `strips` function updated for sorta v11.10.10

-   `kzn_shpec.bash` enables stop_on_error

-   `absolute_path` declares all local variables

-   `absolute_path` uses one less subshell

-   `macros.bash` works with strict_mode

-   `has_length` function incorrectly referenced array, resulting in
    unbound variable error

### Deprecated

-   `shpec_source` - use macro instead

-   `cleanup` - replaced by shpec_cleanup

[v10.10.10] - 2017-02-28
------------------------

### Added

-   first major release - depends on [sorta], which depends in turn on
    [nano]

-   API documentation (still lacking `stripa`, `to_lower` and
    `to_upper`)

  [Keep a Changelog]: http://keepachangelog.com/
  [Semantic Versioning]: http://semver.org/
  [Unreleased]: https://github.com/binaryphile/kaizen/compare/v10.10.10...v10.11
  [v10.10.10]: https://github.com/binaryphile/kaizen/compare/v0.4...v10.10.10
  [sorta]: https://github.com/binaryphile/sorta
  [nano]: https://github.com/binaryphile/nano
