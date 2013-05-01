source "https://rubygems.org"
#source :rubygems

group :development, :test do
  gem 'rake', :require => false
  gem 'veewee', :git => 'git://github.com/jedi4ever/veewee'
  gem 'vagrant', '~> 1.0.5'
  gem 'sahara', '~> 0.0.13'
  gem 'rspec-puppet', '~> 0.1.6', :require => false
  gem 'puppetlabs_spec_helper', '~> 0.4.1', :require => false
  gem 'puppet-lint', '~> 0.3.2', :require => false
end

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 2.7']
gem 'puppet', puppetversion, :require => false
