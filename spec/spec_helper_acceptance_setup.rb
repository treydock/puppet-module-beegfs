def mgmt_ip
  find_only_one(:mgmt).ip
end

collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet5'
if collection == 'puppet6'
  on hosts, puppet('module', 'install', 'puppetlabs-yumrepo_core', '--version', '">= 1.0.1 < 2.0.0"'), { :acceptable_exit_codes => [0,1] }
end

RSpec.configure do |c|
  # Local settings based on environment variables
  c.add_setting :beegfs_release
  c.beegfs_release = ENV['BEAKER_beegfs_release'] || '7.1'
end

on hosts, 'puppet config set --section main show_diff true'
fact_path = File.join(File.dirname(__FILE__), '..', 'lib')
scp_to(hosts, fact_path, '/opt/puppetlabs/puppet/cache/lib')
on hosts, puppet('resource service iptables ensure=stopped'), { :acceptable_exit_codes => [0,1] }
