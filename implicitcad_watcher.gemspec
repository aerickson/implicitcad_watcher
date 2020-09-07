Gem::Specification.new do |s|
  s.name = "implicitcad_watcher"
  s.version = "0.0.2"
  s.date = Time.now.strftime("%Y-%m-%d")

  s.summary = ""
  s.description = ""
  s.authors = ["Andrew Erickson"]
  s.email = "aerickson@gmail.com"
  s.homepage = "https://github.com/aerickson/implicitcad_watcher"
  s.license = "MIT"

  s.files = `git ls-files`.split
  s.executables << "implicitcad_watcher"
  s.executables << "openscad_watcher"
  s.test_files = `git ls-files spec/*`.split

  s.add_dependency "listen", "~> 3.0"

  s.add_development_dependency "codecov", "~> 0.2.0"
  s.add_development_dependency "fuubar", "~> 2.4.1"
  s.add_development_dependency "goodcop", "~> 0.7.0"
  s.add_development_dependency "rake", "~> 13.0.0"
  s.add_development_dependency "rspec", "~> 3.9.0"
  s.add_development_dependency "rubocop", "~> 0.90.0"
end
