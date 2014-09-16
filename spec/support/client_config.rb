shared_context 'fhgfs::client::config' do
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
      :notify   => 'Exec[fhgfs-client rebuild]',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-client-autobuild.conf', [
      'buildArgs=-j8',
      'buildEnabled=true',
    ])
  end

  it do
    should contain_exec('fhgfs-client rebuild').with({
      :command      => '/etc/init.d/fhgfs-client rebuild',
      :refreshonly  => 'true',
    })
  end

  it do
    should contain_file('/etc/fhgfs/interfaces.client').with({
      :ensure => 'file',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  context 'when config_overrides defined' do
    let(:params) do
      {
        :config_overrides => {
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

  context 'when conn_interfaces => ["eth0"]' do
    let(:params) {{ :conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'connInterfacesFile            = /etc/fhgfs/interfaces.client',
      ])
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/interfaces.client', ['eth0'])
    end
  end

  context 'when mount_path => "/fhgfs"' do
    let(:params) {{ :mount_path => "/fhgfs" }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mounts.conf', [
        '/fhgfs /etc/fhgfs/fhgfs-client.conf',
      ])
    end
  end

  context 'when service_autorestart => false' do
    let(:params) {{ :service_autorestart => false }}
    it { should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf').without_notify }
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}
    it { should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf').without_notify }
  end

  context 'when fhgfs::mgmtd_host => "mgmtd.foo"' do
    let(:pre_condition) { "class { 'fhgfs': mgmtd_host => 'mgmtd.foo' }" }

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-client.conf', [
        'sysMgmtdHost                  = mgmtd.foo',
      ])
    end
  end

  context 'when fhgfs::release => "2014.01"' do
    let(:pre_condition) { "class { 'fhgfs': release => '2014.01' }" }

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
  end
end
