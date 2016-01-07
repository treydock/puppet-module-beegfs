shared_examples_for 'beegfs::client::config' do
  it do
    should contain_file('/etc/beegfs').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

=begin
  it do
    should contain_augeas('beegfs-client.conf').with({
      :context  => '/files/etc/beegfs/beegfs-client.conf',
      :lens     => 'BeeGFS_config.lns',
      :incl     => '/etc/beegfs/beegfs-client.conf',
    })
  end

  it do
    verify_augeas_changes(catalogue, 'beegfs-client.conf', [
      "set connAuthFile ''",
      "set connClientPortUDP '8004'",
      "set connCommRetrySecs '600'",
      "set connFallbackExpirationSecs '900'",
      "set connHelperdPortTCP '8006'",
      "set connInterfacesFile ''",
      "set connMaxInternodeNum '12'",
      "set connMgmtdPortTCP '8008'",
      "set connMgmtdPortUDP '8008'",
      "set connNetFilterFile ''",
      "set connPortShift '0'",
      "set connRDMABufNum '128'",
      "set connRDMABufSize '8192'",
      "set connRDMATypeOfService '0'",
      "set connTcpOnlyFilterFile ''",
      "set connUseRDMA 'true'",
      "set logClientID 'false'",
      "set logHelperdIP ''",
      "set logLevel '3'",
      "set logType 'helperd'",
      "set quotaEnabled 'false'",
      "set sysCreateHardlinksAsSymlinks 'false'",
      "set sysMgmtdHost ''",
      "set sysMountSanityCheckMS '11000'",
      "set sysSessionCheckOnClose 'false'",
      "set sysSyncOnClose 'false'",
      "set sysTargetOfflineTimeoutSecs '900'",
      "set sysUpdateTargetStatesSecs '60'",
      "set sysXAttrsEnabled 'false'",
      "set tuneFileCacheType 'buffered'",
      "set tuneNumWorkers '0'",
      "set tunePreferredMetaFile ''",
      "set tunePreferredStorageFile ''",
      "set tuneRemoteFSync 'true'",
      "set tuneUseGlobalAppendLocks 'false'",
      "set tuneUseGlobalFileLocks 'false'",
    ])
  end
=end

  it do
    should contain_file('/etc/beegfs/beegfs-client.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
=begin
    content = catalogue.resource('file', '/etc/beegfs/beegfs-client.conf').send(:parameters)[:content]
    expected_lines = [
      '# --- Section 1.1: [Basic Settings] ---',
      'sysMgmtdHost                  = ',
      '# --- Section 1.2: [Advanced Settings] ---',
      'connAuthFile                  = ',
      'connClientPortUDP             = 8004',
      'connHelperdPortTCP            = 8006',
      'connMgmtdPortTCP              = 8008',
      'connMgmtdPortUDP              = 8008',
      'connPortShift                 = 0',
      'connCommRetrySecs             = 600',
      'connFallbackExpirationSecs    = 900',
      'connInterfacesFile            = ',
      'connMaxInternodeNum           = 12',
      'connNetFilterFile             = ',
      'connTcpOnlyFilterFile         = ',
      'connUseRDMA                   = true',
      'connRDMABufNum                = 128',
      'connRDMABufSize               = 8192',
      'connRDMATypeOfService         = 0',
      'logClientID                   = false',
      'logHelperdIP                  = ',
      'logLevel                      = 3',
      'logType                       = helperd',
      'quotaEnabled                  = false',
      'sysCreateHardlinksAsSymlinks  = false',
      'sysMountSanityCheckMS         = 11000',
      'sysSessionCheckOnClose        = false',
      'sysSyncOnClose                = false',
      'sysTargetOfflineTimeoutSecs   = 900',
      'sysUpdateTargetStatesSecs     = 60',
      'sysXAttrsEnabled              = false',
      'tuneFileCacheType             = buffered',
      'tuneNumWorkers                = 0',
      'tunePreferredMetaFile         = ',
      'tunePreferredStorageFile      = ',
      'tuneRemoteFSync               = true',
      'tuneUseGlobalAppendLocks      = false',
      'tuneUseGlobalFileLocks        = false',
    ]
    pp (content.split("\n") & expected_lines)
    puts "DEBUG"
    pp expected_lines
    puts "DEBUG"
    pp (expected_lines - (content.split("\n") & expected_lines))
    expect(content.split("\n") & expected_lines).to eq(expected_lines)
=end
    verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
      '# --- Section 1.1: [Basic Settings] ---',
      'sysMgmtdHost                  = ',
      '# --- Section 1.2: [Advanced Settings] ---',
      'connAuthFile                  = ',
      'connClientPortUDP             = 8004',
      'connHelperdPortTCP            = 8006',
      'connMgmtdPortTCP              = 8008',
      'connMgmtdPortUDP              = 8008',
      'connPortShift                 = 0',
      'connCommRetrySecs             = 600',
      'connFallbackExpirationSecs    = 900',
      'connInterfacesFile            = ',
      'connMaxInternodeNum           = 12',
      'connNetFilterFile             = ',
      'connTcpOnlyFilterFile         = ',
      'connUseRDMA                   = true',
      'connRDMABufNum                = 128',
      'connRDMABufSize               = 8192',
      'connRDMATypeOfService         = 0',
      'logClientID                   = false',
      'logHelperdIP                  = ',
      'logLevel                      = 3',
      'logType                       = helperd',
      'quotaEnabled                  = false',
      'sysCreateHardlinksAsSymlinks  = false',
      'sysMountSanityCheckMS         = 11000',
      'sysSessionCheckOnClose        = false',
      'sysSyncOnClose                = false',
      'sysTargetOfflineTimeoutSecs   = 900',
      'sysUpdateTargetStatesSecs     = 60',
      'sysXAttrsEnabled              = false',
      'tuneFileCacheType             = buffered',
      'tuneNumWorkers                = 0',
      'tunePreferredMetaFile         = ',
      'tunePreferredStorageFile      = ',
      'tuneRemoteFSync               = true',
      'tuneUseGlobalAppendLocks      = false',
      'tuneUseGlobalFileLocks        = false',
    ])
  end

  it do
    should contain_file('/etc/beegfs/interfaces.client').with({
      :ensure => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('/etc/beegfs/netfilter.client').with({
      :ensure => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('/etc/beegfs/tcp-only-filter').with({
      :ensure => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('/etc/beegfs/beegfs-helperd.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/beegfs/beegfs-helperd.conf', [
      'connAuthFile       = ',
      'connHelperdPortTCP = 8006',
      'connPortShift      = 0',
      'logNoDate          = false',
      'logNumLines        = 50000',
      'logNumRotatedFiles = 5',
      'logStdFile         = /var/log/beegfs-client.log',
      'runDaemonized      = true',
      'tuneNumWorkers     = 2',
    ])
  end

  it do
    should contain_file('/etc/beegfs/beegfs-mounts.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/beegfs/beegfs-mounts.conf', [
      '/mnt/beegfs /etc/beegfs/beegfs-client.conf',
    ])
  end

  it do
    should contain_file('/etc/beegfs/beegfs-client-autobuild.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file_line('beegfs-client-autobuild buildArgs').with({
      :ensure   => 'present',
      :path     => '/etc/beegfs/beegfs-client-autobuild.conf',
      :line     => 'buildArgs=-j8',
      :match    => '^buildArgs=.*$',
      :require  => 'File[/etc/beegfs/beegfs-client-autobuild.conf]',
    })
  end

  it do
    should contain_file_line('beegfs-client-autobuild buildEnabled').with({
      :ensure   => 'present',
      :path     => '/etc/beegfs/beegfs-client-autobuild.conf',
      :line     => 'buildEnabled=true',
      :match    => '^buildEnabled=.*$',
      :require  => 'File[/etc/beegfs/beegfs-client-autobuild.conf]',
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
      verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
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
      verify_contents(catalogue, '/etc/beegfs/beegfs-helperd.conf', [
        'tuneNumWorkers     = 4',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
        'connPortShift                 = 1000',
      ])
    end

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-helperd.conf', [
        'connPortShift      = 1000',
      ])
    end
  end

  context 'when client_conn_interfaces => ["eth0"]' do
    let(:params) {{ :client_conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
        'connInterfacesFile            = /etc/beegfs/interfaces.client',
      ])
    end

    it { should contain_file('/etc/beegfs/interfaces.client').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/interfaces.client', ['eth0'])
    end
  end

  context 'when client_conn_net_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :client_conn_net_filters => ["192.168.1.0/24"] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
        'connNetFilterFile             = /etc/beegfs/netfilter.client',
      ])
    end

    it { should contain_file('/etc/beegfs/netfilter.client').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/netfilter.client', ['192.168.1.0/24'])
    end
  end

  context 'when conn_tcp_only_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :conn_tcp_only_filters => ['192.168.1.0/24', '10.0.0.0/8'] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
        'connTcpOnlyFilterFile         = /etc/beegfs/tcp-only-filter',
      ])
    end

    it do
      should contain_file('/etc/beegfs/tcp-only-filter').with({
        :ensure   => 'present',
        :content  => "192.168.1.0/24\n10.0.0.0/8",
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0644',
      })
    end
  end

  context 'when client_mount_path => "/beegfs"' do
    let(:params) {{ :client_mount_path => "/beegfs" }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-mounts.conf', [
        '/beegfs /etc/beegfs/beegfs-client.conf',
      ])
    end
  end

  context 'when client_service_autorestart => false' do
    let(:params) {{ :client_service_autorestart => false }}
    it { should contain_file('/etc/beegfs/beegfs-client-autobuild.conf').without_notify }
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}
    it { should contain_file('/etc/beegfs/beegfs-client.conf') }
    it { should contain_file('/etc/beegfs/interfaces.client') }
    it { should contain_file('/etc/beegfs/netfilter.client') }
    it { should_not contain_file('/etc/beegfs/beegfs-helperd.conf') }
    it { should_not contain_file('/etc/beegfs/beegfs-mounts.conf') }
    it { should_not contain_file('/etc/beegfs/beegfs-client-autobuild.conf') }
  end

  context 'when beegfs::mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-client.conf', [
        'sysMgmtdHost                  = mgmtd.foo',
      ])
    end
  end
end
