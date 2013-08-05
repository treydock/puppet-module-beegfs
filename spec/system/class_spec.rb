require 'spec_helper_system'

describe 'fhgfs class:' do
  context 'should run successfully' do
    pp = <<-EOS
      file { '/fhgfs':
        ensure  => directory,
      }->
      class { 'fhgfs': }->
      class { 'fhgfs::mgmtd':
        store_mgmtd_directory => '/fhgfs/mgmtd',
      }->
      class { 'fhgfs::meta':
        store_meta_directory  => '/fhgfs/meta',
        mgmtd_host            => 'localhost',
      }->
      class { 'fhgfs::storage':
        store_storage_directory => '/fhgfs/storage',
        mgmtd_host              => 'localhost',
      }->
      file { '/mnt/fhgfs':
        ensure  => directory,
      }->
      class { 'fhgfs::client':
        mgmtd_host => 'localhost',
      }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
    
    context shell('facter --puppet fhgfs_version') do
      its(:stdout) { should =~ /^2012.10.r[0-9]+$/ }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
end
