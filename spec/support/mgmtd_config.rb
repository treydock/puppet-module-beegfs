shared_context 'fhgfs::mgmtd::config' do
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
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'tuneNumWorkers                 = 8',
      ])
    end
  end

  context 'when conn_interfaces => ["eth0"]' do
    let(:params) {{ :conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'connInterfacesFile             = /etc/fhgfs/interfaces.mgmtd',
      ])
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/interfaces.mgmtd', ['eth0'])
    end
  end

  context 'when store_directory => "/fhgfs/mgmtd"' do
    let(:params) {{ :store_directory => "/fhgfs/mgmtd" }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-mgmtd.conf', [
        'storeMgmtdDirectory            = /fhgfs/mgmtd',
      ])
    end
  end

  context 'when fhgfs::release => "2014.01"' do
    let(:pre_condition) { "class { 'fhgfs': release => '2014.01' }" }

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
