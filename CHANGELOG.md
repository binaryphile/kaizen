Change Log
==========

The format is based on [Keep a Changelog] and this project adheres to
[Semantic Versioning].

Latest Changes
==============

[Unreleased]
------------


[v0.5.3] - 2017-05-12
---------------------

### Changed

-   reverted to normal versioning

[v0.5.2] - 2017-04-10
---------------------

### Changed

-   Updated travis dependencies

-   `all-shpecs` echoes command before each output instead of all at top

### Fixed

-   `all-shpecs` script invokes bash explicitly

-   `shpec_cwd` correctly locates the calling file, not
    shpec-helper.bash

Older Changes
=============

[v0.5.1] - 2017-04-07
---------------------

### Added

-   Travis CI support

[v0.5.0] - 2017-04-03
---------------------

### Changed

-   formatting of function declarations to match bash internal format

-   shpec test turns on stop\_on\_error before sourcing kaizen

-   stop\_on\_error turns on nounset and pipefail now

### Added

-   `shpec_cwd` is a macro (variable) meant to replace shpec\_source, to
    prevent scoping issues with declarations (function context) when
    trying to use shpec\_source function

-   `shpec_cleanup` is the new name for `cleanup`, which was too generic
    conflicted with other libraries under test

-   macros for install

### Fixed

-   `strips` function updated for sorta v1.0.0

-   `kzn_shpec.bash` enables stop\_on\_error

-   `absolute_path` declares all local variables

-   `absolute_path` uses one less subshell

-   `macros.bash` works with strict\_mode

-   `has_length` function incorrectly referenced array, resulting in
    unbound variable error

### Deprecated

-   `shpec_source` - use macro instead

-   `cleanup` - replaced by shpec\_cleanup

[v0.4.1] - 2017-02-28
---------------------

### Added

-   first major release - depends on [sorta], which depends in turn on
    [nano]

-   API documentation (still lacking `stripa`, `to_lower` and
    `to_upper`, shpec-helper functions)

  [Keep a Changelog]: http://keepachangelog.com/
  [Semantic Versioning]: http://semver.org/
  [Unreleased]: https://github.com/binaryphile/kaizen/compare/v0.5.2...v0.5
  [v0.5.2]: https://github.com/binaryphile/kaizen/compare/v0.5.1...v0.5.2
  [v0.5.1]: https://github.com/binaryphile/kaizen/compare/v0.5.0...v0.5.1
  [v0.5.0]: https://github.com/binaryphile/kaizen/compare/v0.4.1...v0.5.0
  [v0.4.0]: https://github.com/binaryphile/kaizen/compare/v0.4...v0.4.1
  [sorta]: https://github.com/binaryphile/sorta
  [nano]: https://github.com/binaryphile/nano
