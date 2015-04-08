shared_examples_for 'fhgfs::client::config' do
  it do
    should contain_file('/etc/fhgfs/fhgfs-client.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
      'sysMgmtdHost                  = ',
      '# --- Section 1.2: [Advanced Settings] ---',
      'logLevel                      = 3',
      'logType                       = helperd',
      'logClientID                   = false',
      'logHelperdIP                  = ',
      'connPortShift                 = 0',
      'connMgmtdPortUDP              = 8008',
      'connMgmtdPortTCP              = 8008',
      'connClientPortUDP             = 8004',
      'connHelperdPortTCP            = 8006',
      'connUseSDP                    = false',
      'connUseRDMA                   = true',
      'connRDMABufSize               = 8192',
      'connRDMABufNum                = 128',
      'connRDMATypeOfService         = 0',
      'connMaxInternodeNum           = 12',
      'connInterfacesFile            = ',
      'connNetFilterFile             = ',
      'connFallbackExpirationSecs    = 900',
      'connCommRetrySecs             = 600',
      'connAuthFile                  = ',
      'tuneNumWorkers                = 0',
      'tunePreferredMetaFile         = ',
      'tunePreferredStorageFile      = ',
      'tuneFileCacheType             = buffered',
      'tuneRemoteFSync               = true',
      'tuneUseGlobalFileLocks        = false',
      'tuneUseGlobalAppendLocks      = false',
      'sysCreateHardlinksAsSymlinks  = false',
      'sysMountSanityCheckMS         = 11000',
      'sysSyncOnClose                = false',
      'sysSessionCheckOnClose        = false',
      'quotaEnabled                  = false',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-helperd.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-helperd.conf', [
      'logNoDate          = false',
      'logStdFile         = /var/log/fhgfs-client.log',
      'logNumLines        = 50000',
      'logNumRotatedFiles = 5',
      'connPortShift      = 0',
      'connHelperdPortTCP = 8006',
      'connAuthFile       = ',
      'tuneNumWorkers     = 2',
      'runDaemonized      = true',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-mounts.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-mounts.conf', [
      '/mnt/fhgfs /etc/fhgfs/fhgfs-client.conf',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-client-autobuild.conf', [
      'buildArgs=-j8',
      'buildEnabled=true',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/interfaces.client').with({
      :ensure => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('/etc/fhgfs/netfilter.client').with({
      :ensure => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  context 'when client_config_overrides defined' do
    let(:params) do
      {
        :client_config_overrides => {
          'tuneNumWorkers'  => '8',
        }
      }
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'tuneNumWorkers                = 8',
      ])
    end
  end

  context 'when helperd_config_overrides defined' do
    let(:params) do
      {
        :helperd_config_overrides => {
          'tuneNumWorkers'  => '4',
        }
      }
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-helperd.conf', [
        'tuneNumWorkers     = 4',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'connPortShift                 = 1000',
      ])
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-helperd.conf', [
        'connPortShift      = 1000',
      ])
    end
  end

  context 'when client_conn_interfaces => ["eth0"]' do
    let(:params) {{ :client_conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'connInterfacesFile            = /etc/fhgfs/interfaces.client',
      ])
    end

    it { should contain_file('/etc/fhgfs/interfaces.client').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/fhgfs/interfaces.client', ['eth0'])
    end
  end

  context 'when client_conn_net_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :client_conn_net_filters => ["192.168.1.0/24"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'connNetFilterFile             = /etc/fhgfs/netfilter.client',
      ])
    end

    it { should contain_file('/etc/fhgfs/netfilter.client').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/fhgfs/netfilter.client', ['192.168.1.0/24'])
    end
  end

  context 'when client_mount_path => "/fhgfs"' do
    let(:params) {{ :client_mount_path => "/fhgfs" }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mounts.conf', [
        '/fhgfs /etc/fhgfs/fhgfs-client.conf',
      ])
    end
  end

  context 'when client_service_autorestart => false' do
    let(:params) {{ :client_service_autorestart => false }}
    it { should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf').without_notify }
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}
    it { should contain_file('/etc/fhgfs/fhgfs-client.conf') }
    it { should_not contain_file('/etc/fhgfs/fhgfs-helperd.conf') }
    it { should_not contain_file('/etc/fhgfs/fhgfs-mounts.conf') }
    it { should_not contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') }
  end

  context 'when fhgfs::mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'sysMgmtdHost                  = mgmtd.foo',
      ])
    end
  end

  context 'when fhgfs::release => "2012.10"' do
    let(:params) {{ :release => '2012.10' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'logLevel                      = 3',
        'logType                       = helperd',
        'logClientID                   = false',
        'logHelperdIP                  = ',
        'connPortShift                 = 0',
        'connMgmtdPortUDP              = 8008',
        'connMgmtdPortTCP              = 8008',
        'connClientPortUDP             = 8004',
        'connHelperdPortTCP            = 8006',
        'connUseSDP                    = false',
        'connUseRDMA                   = true',
        'connRDMABufSize               = 8192',
        'connRDMABufNum                = 128',
        'connRDMATypeOfService         = 0',
        'connMaxInternodeNum           = 12',
        'connInterfacesFile            = ',
        'connNetFilterFile             = ',
        'connNonPrimaryExpiration      = 10000',
        'connCommRetrySecs             = 600',
        'tuneNumWorkers                = 0',
        'tunePreferredMetaFile         = ',
        'tunePreferredStorageFile      = ',
        'tuneFileCacheType             = buffered',
        'tuneRemoteFSync               = true',
        'tuneUseGlobalFileLocks        = false',
        'sysMgmtdHost                  = ',
        'sysCreateHardlinksAsSymlinks  = true',
        'sysMountSanityCheckMS         = 11000',
        'sysSyncOnClose                = false',
        'sysSessionCheckOnClose        = false',
        'quotaEnabled                  = false',
      ])
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-helperd.conf', [
        'logNoDate          = false',
        'logStdFile         = /var/log/fhgfs-client.log',
        'logNumLines        = 50000',
        'logNumRotatedFiles = 5',
        'connPortShift      = 0',
        'connHelperdPortTCP = 8006',
        'tuneNumWorkers     = 2',
        'runDaemonized      = true',
      ])
    end
  end
end
