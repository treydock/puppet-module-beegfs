shared_context 'beegfs::storage::config' do
  it do
    should contain_file('/etc/beegfs').with({
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it { should_not contain_file('beegfs-storeStorageDirectory') }

  it do
    should contain_file('/etc/beegfs/beegfs-storage.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
      '# --- Section 1.1: [Basic Settings] ---',
      'sysMgmtdHost                 = ',
      'storeStorageDirectory        = ',
      'storeAllowFirstRunInit       = true',
      '# --- Section 1.2: [Advanced Settings] ---',
      'connAuthFile                 = ',
      'connBacklogTCP               = 128',
      'connInterfacesFile           = ',
      'connMaxInternodeNum          = 12',
      'connMgmtdPortTCP             = 8008',
      'connMgmtdPortUDP             = 8008',
      'connStoragePortTCP           = 8003',
      'connStoragePortUDP           = 8003',
      'connPortShift                = 0',
      'connNetFilterFile            = ',
      'connTcpOnlyFilterFile        = ',
      'connUseRDMA                  = true',
      'connRDMATypeOfService        = 0',
      'logLevel                     = 3',
      'logNoDate                    = false',
      'logNumLines                  = 50000',
      'logNumRotatedFiles           = 5',
      'logStdFile                   = /var/log/beegfs-storage.log',
      'quotaEnableEnforcement       = false',
      'runDaemonized                = true',
      'sysResyncSafetyThresholdMins = 10',
      'sysTargetOfflineTimeoutSecs  = 180',
      'sysUpdateTargetStatesSecs    = 30',
      'tuneBindToNumaZone           = ',
      'tuneFileReadAheadSize        = 0m',
      'tuneFileReadAheadTriggerSize = 4m',
      'tuneFileReadSize             = 32k',
      'tuneFileWriteSize            = 64k',
      'tuneFileWriteSyncSize        = 0m',
      'tuneNumResyncGatherSlaves    = 6',
      'tuneNumResyncSlaves          = 12',
      'tuneNumStreamListeners       = 1',
      'tuneNumWorkers               = 12',
      'tuneUseAggressiveStreamPoll  = false',
      'tuneUsePerTargetWorkers      = true',
      'tuneUsePerUserMsgQueues      = false',
      'tuneWorkerBufSize            = 4m',
    ])
  end

  it do
    should contain_file('/etc/beegfs/interfaces.storage').with({
      :ensure   => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('/etc/beegfs/netfilter.storage').with({
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

  context 'when storage_config_overrides defined' do
    let(:params) {{ :storage => true, :storage_config_overrides => {'tuneNumWorkers'  => '24'} }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
        'tuneNumWorkers               = 24',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :storage => true, :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
        'connPortShift                = 1000',
      ])
    end
  end

  context 'when storage_conn_interfaces => ["eth0"]' do
    let(:params) {{ :storage => true, :storage_conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
        'connInterfacesFile           = /etc/beegfs/interfaces.storage',
      ])
    end

    it { should contain_file('/etc/beegfs/interfaces.storage').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/interfaces.storage', ['eth0'])
    end
  end

  context 'when storage_conn_net_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :storage => true, :storage_conn_net_filters => ["192.168.1.0/24"] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
        'connNetFilterFile            = /etc/beegfs/netfilter.storage',
      ])
    end

    it { should contain_file('/etc/beegfs/netfilter.storage').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/netfilter.storage', ['192.168.1.0/24'])
    end
  end

  context 'when conn_tcp_only_filters => ["192.168.1.0/24"]' do
    let(:params) {{ :storage => true, :conn_tcp_only_filters => ['192.168.1.0/24', '10.0.0.0/8'] }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
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

  context 'when storage_store_directory => "/beegfs/storage"' do
    let(:params) {{ :storage => true, :storage_store_directory => "/beegfs/storage" }}

    it do
      should contain_file('beegfs-storeStorageDirectory').with({
        :ensure => 'directory',
        :path   => '/beegfs/storage',
      })
    end

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
        'storeStorageDirectory        = /beegfs/storage',
      ])
    end
  end

  context 'when mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :storage => true, :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-storage.conf', [
        'sysMgmtdHost                 = mgmtd.foo',
      ])
    end
  end
end
