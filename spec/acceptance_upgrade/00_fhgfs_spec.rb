require 'spec_helper_acceptance_upgrade'

describe 'fhgfs class:' do
  context 'with mgmtd and admon' do
    node = find_only_one(:mgmt)

    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs':
          mgmtd                 => true,
          admon                 => true,
          utils_only            => true,
          mgmtd_host            => '#{mgmt_ip}',
          release               => '2014.01',
          mgmtd_service_ensure  => 'running',
          mgmtd_service_enable  => true,
          mgmtd_store_directory => '/fhgfs/mgmtd',
          admon_service_ensure  => 'running',
          admon_service_enable  => true,
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end
  end

  context 'with meta' do
    node = find_only_one(:meta)

    it 'should run successfully' do
      pp = <<-EOS
      file { '/fhgfs':
        ensure  => directory,
      }->
      class { 'fhgfs':
        meta                  => true,
        utils_only            => true,
        mgmtd_host            => '#{mgmt_ip}',
        release               => '2014.01',
        meta_service_ensure   => 'running',
        meta_service_enable   => true,
        meta_store_directory  => '/fhgfs/meta',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end
  end

  context 'with storage' do
    node = find_only_one(:storage)

    it 'should run successfully' do
      pp = <<-EOS
      file { '/fhgfs':
        ensure  => directory,
      }->
      class { 'fhgfs':
        storage                 => true,
        utils_only              => true,
        mgmtd_host              => '#{mgmt_ip}',
        release                 => '2014.01',
        storage_service_ensure  => 'running',
        storage_service_enable  => true,
        storage_store_directory => '/fhgfs/storage',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end
  end

  context 'with client' do
    node = find_only_one(:client)

    it 'should run successfully' do
      if node['hypervisor'] =~ /docker/
        manage_client_dependencies = 'false'
        client_package_dependencies = '[]'
      else
        manage_client_dependencies = 'true'
        client_package_dependencies = 'undef'
      end
      pp = <<-EOS
      class { 'fhgfs':
        mgmtd_host                  => '#{mgmt_ip}',
        release                     => '2014.01',
        client_mount_path           => '/data',
        manage_client_dependencies  => #{manage_client_dependencies},
        client_package_dependencies => #{client_package_dependencies},
      }
      EOS

      # Docker based tests fail to start client service as kernel module must be compiled
      if node['hypervisor'] =~ /docker/
        apply_manifest_on(node, pp, :catch_failures => false)
      else
        apply_manifest_on(node, pp, :catch_failures => true)
        apply_manifest_on(node, pp, :catch_changes => true)
      end
    end
  end
end


