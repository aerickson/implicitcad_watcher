implicitcad_watcher
=========

[![Gem Version](https://img.shields.io/gem/v/implicitcad_watcher.svg)](https://rubygems.org/gems/implicitcad_watcher)
[![Build Status](https://img.shields.io/circleci/project/aerickson/implicitcad_watcher.svg)](https://circleci.com/gh/aerickson/implicitcad_watcher)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

## overview

implicitcad_watcher watches any .escad files in the current directory and recompiles them with ImplicitCAD (http://www.implicitcad.org/).

ImplicitCAD lacks an IDE like OpenSCAD and this makes it much easier to iterate on designs and get rapid feedback. I use OS X's Finder preview functionality for displaying the resulting STL file.

## `openscad_watcher`

Some things just don't work in ImplicitCAD, so it's nice to be able to render with OpenSCAD. That's what openscad_watcher is for! It watches .scad files and renders them to STL's just like implicitcad_watcher.

ImplicitCAD has features that OpenSCAD doesn't, so not everything will work.

## Usage

```
cd directory_with_escad_files
implicitcad_watcher
// edit escad
// view resulting stl file
// repeat (edit and view cycle)
```

## Installation

```
gem install specific_install
gem specific_install -l https://www.github.com/aerickson/implicitcad_watcher
```

## Development

### Running Locally

`ruby -Ilib bin/implicitcad_watcher`

### TODO

- merge openscad_watcher and implicitcad_watcher
- openscad_watcher: work on .escad or .scad files
- arg parsing
  - verbose/debug mode
- don't expect implicitcad in cabal location?
  - look for on path or take config?

## Links

- http://www.implicitcad.org/
- https://www.openscad.org/

## License

implicitcad_watcher is released under the MIT License. See the bundled LICENSE file for details.

