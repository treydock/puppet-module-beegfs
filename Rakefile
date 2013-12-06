require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'rspec-system/rake_task'

task :default do
  sh %{rake -T}
end

desc "Run puppet-syntax, puppet-lint and rspec-puppet tasks"
task :ci => [:syntax, :lint, :spec]

Rake::Task[:spec_system].clear

RSpec::Core::RakeTask.new(:spec_system) do |c|
  c.pattern = "spec/system/*_spec.rb"
  c.rspec_opts = %w[--require rspec-system/formatter --format=RSpecSystem::Formatter]
end

RSpec::Core::RakeTask.new(:spec_system_multinode) do |c|
  c.pattern = "spec/system/multinode/*_spec.rb"
  c.rspec_opts = %w[--require rspec-system/formatter --format=RSpecSystem::Formatter]
end

namespace :spec do
  namespace :system do
    desc 'Run multi-node system tests'
    task :multinode => :spec_system_multinode
  end
end

# Disable puppet-lint checks
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_class_inherits_from_params_class")
PuppetLint.configuration.send('disable_quoted_booleans')
PuppetLint.configuration.send('disable_only_variable_string')
PuppetLint.configuration.send('disable_class_parameter_defaults')

# Ignore files outside this module
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp", "vendor/**/*.pp", "spec/**/*.pp"]
PuppetSyntax.exclude_paths = ["pkg/**/*.pp", "vendor/**/*.pp", "spec/**/*.pp"]
