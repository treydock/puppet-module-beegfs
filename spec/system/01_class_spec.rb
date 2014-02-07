require 'spec_helper_system'

describe 'fhgfs class:' do
  context 'all-in-one configuration' do
    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }

        class { 'fhgfs': }->
        class { 'fhgfs::mgmtd':
          service_ensure        => 'running',
          service_enable        => true,
          store_mgmtd_directory => '/fhgfs/mgmtd',
          require               => File['/fhgfs'],
        }->
        class { 'fhgfs::meta':
          service_ensure        => 'running',
          service_enable        => true,
          store_meta_directory  => '/fhgfs/meta',
          mgmtd_host            => 'localhost',
          require               => File['/fhgfs'],
        }->
        class { 'fhgfs::storage':
          service_ensure          => 'running',
          service_enable        => true,
          store_storage_directory => '/fhgfs/storage',
          mgmtd_host              => 'localhost',
          require                 => File['/fhgfs'],
        }->
        class { 'fhgfs::client':
          mgmtd_host => 'localhost',
        }->
        class { 'fhgfs::admon':
          service_ensure      => 'running',
          service_enable      => true,
          mgmtd_host          => 'localhost',
        }
      EOS

      puppet_apply(pp) do |r|
       r.exit_code.should_not == 1
       r.refresh
       r.exit_code.should be_zero
      end
    end

    [
      'fhgfs-mgmtd',
      'fhgfs-meta',
      'fhgfs-storage',
      'fhgfs-helperd',
      'fhgfs-client',
      'fhgfs-admon',
    ].each do |service|
      describe service(service) do
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end
