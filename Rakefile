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

desc "default rake commands"
task :rdefault do
  Rake::Task["rubocop"].invoke
  Rake::Task["rufo:check"].invoke
  Rake::Task["build"].invoke
  Rake::Task["install"].invoke
end

#task default: %i[spec rubocop build install]
task default: %i[spec rufo:check rubocop build install]
#"spec",
# task :default => [
#   "rufo:check",
#   :rubocop,
#   :build,
#   :install,
# ]

# task default: %i[rdefault]
