require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

desc "Run tests"
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Run Rubocop on the gem"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = true
end

task default: %i[spec rufo:check rubocop build install]
