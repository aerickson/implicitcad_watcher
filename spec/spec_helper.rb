if ENV["CI"] == "true"
  require "simplecov"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  SimpleCov.start do
    add_filter "/spec/"
  end
end

if ENV["COV"] == "true"
  require "simplecov"
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require "rspec"
require "cad_watcher"
