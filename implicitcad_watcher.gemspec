  lib = File.expand_path('../lib', __FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
  require './lib/version'

Gem::Specification.new do |s|
  s.name = "implicitcad_watcher"
  s.version = ImplicitcadWatcher::VERSION

  s.summary = "A file watcher for ImplicitCAD and OpenSCAD projects."
  s.description = "Automatically watches your ImplicitCAD and OpenSCAD project files and triggers rebuilds when changes are detected. It streamlines the workflow for CAD development by providing instant feedback and automation."
  s.authors = ["Andrew Erickson"]
  s.email = "aerickson@gmail.com"
  s.homepage = "https://github.com/aerickson/implicitcad_watcher"
  s.license = "MIT"
  s.required_ruby_version = '>= 2.6.0'

  s.files = `git ls-files`.split
  s.executables << "implicitcad_watcher"
  s.executables << "openscad_watcher"
  s.test_files = `git ls-files spec/*`.split

  s.add_dependency "listen", "~> 3.0"

  s.add_development_dependency "codecov", "~> 0.6.0"
  s.add_development_dependency "fuubar", "~> 2.4.1"
  s.add_development_dependency "goodcop", "~> 0.7.0"
  s.add_development_dependency "rake", "~> 13.3.0"
  s.add_development_dependency "rspec", "~> 3.13.1"
  s.add_development_dependency "rubocop", "~> 1.50.2"
end
