source "http://rubygems.org"

group :development, :test do
  gem 'rake',                   :require => false
  gem 'rspec', '< 3.0.0',       :require => false
  gem 'rspec-puppet',           :require => false, :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper', '~> 0.4.0', :require => false
  gem 'puppet-lint',            :require => false
  gem 'puppet-syntax',          :require => false
  gem 'travis-lint',            :require => false
  gem 'simplecov',              :require => false
  gem 'coveralls',              :require => false
end

group :development do
  gem 'beaker',                 :require => false
  gem 'beaker-rspec',           :require => false
  gem 'system_timer',           :require => false
  gem 'vagrant-wrapper',        :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '~> 3.5.0', :require => false
end
