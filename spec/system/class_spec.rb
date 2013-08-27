require 'spec_helper_system'

describe 'fhgfs class:' do
  context 'should run successfully' do
    pp = <<-EOS
      file { '/fhgfs':
        ensure  => directory,
      }

      class { 'fhgfs': }->
      class { 'fhgfs::mgmtd':
        store_mgmtd_directory => '/fhgfs/mgmtd',
        require               => File['/fhgfs'],
      }->
      class { 'fhgfs::meta':
        store_meta_directory  => '/fhgfs/meta',
        mgmtd_host            => 'localhost',
        require               => File['/fhgfs'],
      }->
      class { 'fhgfs::storage':
        store_storage_directory => '/fhgfs/storage',
        mgmtd_host              => 'localhost',
        require                 => File['/fhgfs'],
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

    [
      'fhgfs-mgmtd',
      'fhgfs-meta',
      'fhgfs-storage',
      'fhgfs-helperd',
      'fhgfs-client'
    ].each do |service|      
      describe service(service) do
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end
