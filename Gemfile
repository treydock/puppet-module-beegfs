source "https://rubygems.org"

group :development, :test do
  gem 'rake'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet-lint', '~> 0.3.2'
  gem 'puppet-syntax'
  gem 'travis-lint'
  gem 'rspec-system', '~> 2.8.0'
  gem 'rspec-system-puppet', '~> 2.0'
  gem 'serverspec', '~> 0.11.0'
  gem 'rspec-system-serverspec', '~> 1.0.1'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
