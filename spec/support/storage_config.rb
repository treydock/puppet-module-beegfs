shared_context 'fhgfs::storage::config' do
  it do
    should contain_file('/etc/fhgfs/fhgfs-storage.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-storage.conf', [
      'logLevel                     = 3',
      'logNoDate                    = false',
      'logStdFile                   = /var/log/fhgfs-storage.log',
      'logNumLines                  = 50000',
      'logNumRotatedFiles           = 5',
      'connPortShift                = 0',
      'connMgmtdPortUDP             = 8008',
      'connMgmtdPortTCP             = 8008',
      'connStoragePortUDP           = 8003',
      'connStoragePortTCP           = 8003',
      'connUseSDP                   = false',
      'connUseRDMA                  = true',
      'connRDMATypeOfService        = 0',
      'connBacklogTCP               = 128',
      'connInterfacesFile           = ',
      'connNetFilterFile            = ',
      'storeStorageDirectory        = ',
      'storeAllowFirstRunInit       = true',
      'tuneNumWorkers               = 12',
      'tuneBindToNumaZone           = ',
      'tuneWorkerBufSize            = 4m',
      'tuneFileReadSize             = 32k',
      'tuneFileReadAheadTriggerSize = 4m',
      'tuneFileReadAheadSize        = 0m',
      'tuneFileWriteSize            = 64k',
      'tuneFileWriteSyncSize        = 0m',
      'tuneUsePerUserMsgQueues      = false',
      'sysMgmtdHost                 = ',
      'runDaemonized                = true',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/interfaces.storage').with({
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
          'tuneNumWorkers'  => '24',
        }
      }
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-storage.conf', [
        'tuneNumWorkers               = 24',
      ])
    end
  end

  context 'when conn_interfaces => ["eth0"]' do
    let(:params) {{ :conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-storage.conf', [
        'connInterfacesFile           = /etc/fhgfs/interfaces.storage',
      ])
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/interfaces.storage', ['eth0'])
    end
  end

  context 'when store_directory => "/fhgfs/storage"' do
    let(:params) {{ :store_directory => "/fhgfs/storage" }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-storage.conf', [
        'storeStorageDirectory        = /fhgfs/storage',
      ])
    end
  end

  context 'when fhgfs::mgmtd_host => "mgmtd.foo"' do
    let(:pre_condition) { "class { 'fhgfs': mgmtd_host => 'mgmtd.foo' }" }

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-storage.conf', [
        'sysMgmtdHost                 = mgmtd.foo',
      ])
    end
  end

  context 'when fhgfs::release => "2014.01"' do
    let(:pre_condition) { "class { 'fhgfs': release => '2014.01' }" }

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-storage.conf', [
        'sysMgmtdHost                 = ',
        'storeStorageDirectory        = ',
        'storeAllowFirstRunInit       = true',
        '# --- Section 1.2: [Advanced Settings] ---',
        'logLevel                     = 3',
        'logNoDate                    = false',
        'logStdFile                   = /var/log/fhgfs-storage.log',
        'logNumLines                  = 50000',
        'logNumRotatedFiles           = 5',
        'connPortShift                = 0',
        'connMgmtdPortUDP             = 8008',
        'connMgmtdPortTCP             = 8008',
        'connStoragePortUDP           = 8003',
        'connStoragePortTCP           = 8003',
        'connUseSDP                   = false',
        'connUseRDMA                  = true',
        'connRDMATypeOfService        = 0',
        'connBacklogTCP               = 128',
        'connInterfacesFile           = ',
        'connNetFilterFile            = ',
        'connAuthFile                 = ',
        'tuneNumWorkers               = 12',
        'tuneBindToNumaZone           = ',
        'tuneWorkerBufSize            = 4m',
        'tuneFileReadSize             = 32k',
        'tuneFileReadAheadTriggerSize = 4m',
        'tuneFileReadAheadSize        = 0m',
        'tuneFileWriteSize            = 64k',
        'tuneFileWriteSyncSize        = 0m',
        'tuneUsePerUserMsgQueues      = false',
        'runDaemonized                = true',
      ])
    end
  end
end
