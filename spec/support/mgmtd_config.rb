shared_examples_for 'fhgfs::mgmtd::config' do
  it do
    should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
      'logLevel                       = 2',
      'logNoDate                      = false',
      'logStdFile                     = /var/log/fhgfs-mgmtd.log',
      'logNumLines                    = 50000',
      'logNumRotatedFiles             = 5',
      'connPortShift                  = 0',
      'connMgmtdPortUDP               = 8008',
      'connMgmtdPortTCP               = 8008',
      'connBacklogTCP                 = 128',
      'connInterfacesFile             = ',
      'connNetFilterFile              = ',
      'storeMgmtdDirectory            = ',
      'storeAllowFirstRunInit         = true',
      'tuneNumWorkers                 = 4',
      'tuneClientAutoRemoveMins       = 30',
      'tuneMetaSpaceLowLimit          = 10G',
      'tuneMetaSpaceEmergencyLimit    = 3G',
      'tuneStorageSpaceLowLimit       = 512G',
      'tuneStorageSpaceEmergencyLimit = 10G',
      'sysAllowNewServers             = true',
      'sysForcedRoot                  = 0',
      'sysOverrideStoredRoot          = false',
      'runDaemonized                  = true',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/interfaces.mgmtd').with({
      :ensure   => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  context 'when mgmtd_config_overrides defined' do
    let(:params) {{ :mgmtd => true, :mgmtd_config_overrides => {'tuneNumWorkers'  => '8'} }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'tuneNumWorkers                 = 8',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :mgmtd => true, :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'connPortShift                  = 1000',
      ])
    end
  end

  context 'when mgmtd_conn_interfaces => ["eth0"]' do
    let(:params) {{ :mgmtd => true, :mgmtd_conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'connInterfacesFile             = /etc/fhgfs/interfaces.mgmtd',
      ])
    end

    it { should contain_file('/etc/fhgfs/interfaces.mgmtd').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/fhgfs/interfaces.mgmtd', ['eth0'])
    end
  end

  context 'when mgmtd_store_directory => "/fhgfs/mgmtd"' do
    let(:params) {{ :mgmtd => true, :mgmtd_store_directory => "/fhgfs/mgmtd" }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'storeMgmtdDirectory            = /fhgfs/mgmtd',
      ])
    end
  end

  context 'when release => "2014.01"' do
    let(:params) {{ :mgmtd => true, :release => '2014.01' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'storeMgmtdDirectory            = ',
        'storeAllowFirstRunInit         = true',
        'sysAllowNewServers             = true',
        '# --- Section 1.2: [Advanced Settings] ---',
        'logLevel                       = 2',
        'logNoDate                      = false',
        'logStdFile                     = /var/log/fhgfs-mgmtd.log',
        'logNumLines                    = 50000',
        'logNumRotatedFiles             = 5',
        'connPortShift                  = 0',
        'connMgmtdPortUDP               = 8008',
        'connMgmtdPortTCP               = 8008',
        'connBacklogTCP                 = 128',
        'connInterfacesFile             = ',
        'connNetFilterFile              = ',
        'connAuthFile                   = ',
        'tuneNumWorkers                 = 4',
        'tuneClientAutoRemoveMins       = 30',
        'tuneMetaSpaceLowLimit          = 10G',
        'tuneMetaSpaceEmergencyLimit    = 3G',
        'tuneStorageSpaceLowLimit       = 512G',
        'tuneStorageSpaceEmergencyLimit = 10G',
        'runDaemonized                  = true',
      ])
    end
  end
end
