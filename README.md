implicitcad_watcher
=========

[![Gem Version](https://img.shields.io/gem/v/implicitcad_watcher.svg)](https://rubygems.org/gems/implicitcad_watcher)
[![Dependency Status](https://img.shields.io/gemnasium/aerickson/implicitcad_watcher.svg)](https://gemnasium.com/aerickson/implicitcad_watcher)
[![Build Status](https://img.shields.io/circleci/project/aerickson/implicitcad_watcher.svg)](https://circleci.com/gh/aerickson/implicitcad_watcher)
[![Coverage Status](https://img.shields.io/codecov/c/github/aerickson/implicitcad_watcher.svg)](https://codecov.io/github/aerickson/implicitcad_watcher)
[![Code Quality](https://img.shields.io/codacy/.svg)](https://www.codacy.com/app/aerickson/implicitcad_watcher)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

implicitcad_watcher watches any .escad files in the current directory and recompiles them with ImplicitCAD (http://www.implicitcad.org/).

ImplicitCAD lacks an IDE like OpenSCAD and this makes it much easier to iterate on designs and get rapid feedback. I use OS X's Finder preview functionality displaying the STL file.

## Usage

```
cd directory_with_escad_files
implicitcad_watcher
// edit escad
// view resulting stl file
// repeat (edit and view cycle)
```

## Installation

`gem install https://www.github.com/aerickson/implicitcad_watcher`

## TODO

- arg parsing
  - verbose/debug mode
- write blah.escad out to blah.stl vs output.stl

## License

implicitcad_watcher is released under the MIT License. See the bundled LICENSE file for details.

