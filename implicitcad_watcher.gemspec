Gem::Specification.new do |s|
  s.name        = 'implicitcad_watcher'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.summary     = ''
  s.description = ''
  s.authors     = ['Andrew Erickson']
  s.email       = 'aerickson@gmail.com'
  s.homepage    = 'https://github.com/aerickson/implicitcad_watcher'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_dependency 'listen', '~> 3.0'

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.3.0'
  s.add_development_dependency 'goodcop', '~> 0.5.0'
  s.add_development_dependency 'rake', '~> 12.3.0'
  s.add_development_dependency 'rspec', '~> 3.7.0'
  s.add_development_dependency 'rubocop', '~> 0.57.1'
end
