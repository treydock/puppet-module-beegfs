shared_context 'beegfs::meta::config' do
  it do
    should contain_file('/etc/beegfs').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it { should_not contain_file('beegfs-storeMetaDirectory') }

  it do
    should contain_file('/etc/beegfs/beegfs-meta.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
      '# --- Section 1.1: [Basic Settings] ---',
      'sysMgmtdHost                 = ',
      'storeMetaDirectory           = ',
      'storeAllowFirstRunInit       = true',
      '# --- Section 1.2: [Advanced Settings] ---',
      'connAuthFile                 = ',
      'connBacklogTCP               = 128',
      'connFallbackExpirationSecs   = 900',
      'connInterfacesFile           = ',
      'connMaxInternodeNum          = 32',
      'connMetaPortTCP              = 8005',
      'connMetaPortUDP              = 8005',
      'connMgmtdPortTCP             = 8008',
      'connMgmtdPortUDP             = 8008',
      'connPortShift                = 0',
      'connNetFilterFile            = ',
      'connUseRDMA                  = true',
      'connRDMATypeOfService        = 0',
      'connTcpOnlyFilterFile        = ',
      'logType                      = logfile',
      'logLevel                     = 3',
      'logNoDate                    = false',
      'logNumLines                  = 50000',
      'logNumRotatedFiles           = 5',
      'logStdFile                   = /var/log/beegfs-meta.log',
      'runDaemonized                = true',
      'storeClientXAttrs            = false',
      'storeClientACLs              = false',
      'storeUseExtendedAttribs      = true',
      'sysTargetAttachmentFile      = ',
      'sysTargetOfflineTimeoutSecs  = 180',
      'sysAllowUserSetPattern       = false',
      'tuneBindToNumaZone           = ',
      'tuneNumStreamListeners       = 1',
      'tuneNumWorkers               = 0',
      'tuneTargetChooser            = randomized',
      'tuneUseAggressiveStreamPoll  = false',
      'tuneUsePerUserMsgQueues      = false',
    ])
  end

  it do
    should contain_file('/etc/beegfs/interfaces.meta').with({
      :ensure   => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('/etc/beegfs/netfilter.meta').with({
      :ensure   => 'absent',
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

  context 'when meta_config_overrides defined' do
    let(:params) {{ :meta => true, :meta_config_overrides => {'tuneNumWorkers'  => '8' } }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'tuneNumWorkers               = 8',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :meta => true, :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'connPortShift                = 1000',
      ])
    end
  end

  context 'when meta_conn_interfaces => ["eth0"]' do
    let(:params) {{ :meta => true, :meta_conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'connInterfacesFile           = /etc/beegfs/interfaces.meta',
      ])
    end

    it { should contain_file('/etc/beegfs/interfaces.meta').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/interfaces.meta', ['eth0'])
    end
  end

  context 'when meta_conn_net_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :meta => true, :meta_conn_net_filters => ["192.168.1.0/24"] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'connNetFilterFile            = /etc/beegfs/netfilter.meta',
      ])
    end

    it { should contain_file('/etc/beegfs/netfilter.meta').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/netfilter.meta', ['192.168.1.0/24'])
    end
  end

  context 'when conn_tcp_only_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :meta => true, :conn_tcp_only_filters => ['192.168.1.0/24', '10.0.0.0/8'] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'connTcpOnlyFilterFile        = /etc/beegfs/tcp-only-filter',
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

  context 'when meta_store_directory => "/beegfs/meta"' do
    let(:params) {{ :meta => true, :meta_store_directory => "/beegfs/meta" }}

    it do
      should contain_file('beegfs-storeMetaDirectory').with({
        :ensure => 'directory',
        :path   => '/beegfs/meta',
      })
    end

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'storeMetaDirectory           = /beegfs/meta',
      ])
    end
  end

  context 'when mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :meta => true, :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-meta.conf', [
        'sysMgmtdHost                 = mgmtd.foo',
      ])
    end
  end
end
