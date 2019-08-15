shared_examples_for 'beegfs::mgmtd::config' do
  it do
    is_expected.to contain_file('/etc/beegfs').with(ensure: 'directory',
                                                    owner: 'root',
                                                    group: 'root',
                                                    mode: '0755')
  end

  it { is_expected.not_to contain_file('beegfs-storeMgmtdDirectory') }

  it do
    is_expected.to contain_file('/etc/beegfs/beegfs-mgmtd.conf').with(ensure: 'present',
                                                                      owner: 'root',
                                                                      group: 'root',
                                                                      mode: '0644')
  end

  it do
    expected = [
      '# --- Section 1.1: [Basic Settings] ---',
      'storeMgmtdDirectory                    = ',
      'storeAllowFirstRunInit                 = true',
      'sysAllowNewServers                     = true',
      'sysAllowNewTargets                     = true',
      '# --- Section 1.2: [Advanced Settings] ---',
      'connAuthFile                           = ',
      'connBacklogTCP                         = 128',
      'connInterfacesFile                     = ',
      'connMgmtdPortTCP                       = 8008',
      'connMgmtdPortUDP                       = 8008',
      'connNetFilterFile                      = ',
      'connPortShift                          = 0',
      'logType                                = logfile',
      'logLevel                               = 2',
      'logNoDate                              = false',
      'logNumLines                            = 50000',
      'logNumRotatedFiles                     = 5',
      'logStdFile                             = /var/log/beegfs-mgmtd.log',
      'quotaQueryGIDFile                      = ',
      'quotaQueryGIDRange                     = ',
      'quotaQueryUIDFile                      = ',
      'quotaQueryUIDRange                     = ',
      'quotaQueryType                         = system',
      'quotaQueryWithSystemUsersGroups        = false',
      'quotaUpdateIntervalMin                 = 10',
      'runDaemonized                          = true',
      'sysTargetOfflineTimeoutSecs            = 180',
      'tuneClientAutoRemoveMins               = 30',
      'tuneNumWorkers                         = 4',
      'tuneMetaDynamicPools                   = true',
      'tuneMetaInodesLowLimit                 = 10M',
      'tuneMetaInodesEmergencyLimit           = 1M',
      'tuneMetaSpaceLowLimit                  = 10G',
      'tuneMetaSpaceEmergencyLimit            = 3G',
      'tuneStorageDynamicPools                = true',
      'tuneStorageInodesLowLimit              = 10M',
      'tuneStorageInodesEmergencyLimit        = 1M',
      'tuneStorageSpaceLowLimit               = 1T',
      'tuneStorageSpaceEmergencyLimit         = 20G',
      '# --- Section 1.3: [Enterprise Features] ---',
      'quotaEnableEnforcement                 = false',
    ]
    content = catalogue.resource('file', '/etc/beegfs/beegfs-mgmtd.conf').send(:parameters)[:content]
    pp(expected - (content.split(%r{\n}).reject { |line| line =~ %r{(^#|^$)} } & expected))
    verify_contents(catalogue, '/etc/beegfs/beegfs-mgmtd.conf', expected)
  end

  it do
    is_expected.to contain_file('/etc/beegfs/interfaces.mgmtd').with(ensure: 'absent',
                                                                     content: %r{^$},
                                                                     owner: 'root',
                                                                     group: 'root',
                                                                     mode: '0644')
  end

  it do
    is_expected.to contain_file('/etc/beegfs/netfilter.mgmtd').with(ensure: 'absent',
                                                                    content: %r{^$},
                                                                    owner: 'root',
                                                                    group: 'root',
                                                                    mode: '0644')
  end

  context 'when mgmtd_config_overrides defined' do
    let(:params) { { mgmtd: true, mgmtd_config_overrides: { 'tuneNumWorkers' => '8' } } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-mgmtd.conf', [
                        'tuneNumWorkers                         = 8',
                      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) { { mgmtd: true, conn_port_shift: 1000 } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-mgmtd.conf', [
                        'connPortShift                          = 1000',
                      ])
    end
  end

  context 'when mgmtd_conn_interfaces => ["eth0"]' do
    let(:params) { { mgmtd: true, mgmtd_conn_interfaces: ['eth0'] } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-mgmtd.conf', [
                        'connInterfacesFile                     = /etc/beegfs/interfaces.mgmtd',
                      ])
    end

    it { is_expected.to contain_file('/etc/beegfs/interfaces.mgmtd').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/interfaces.mgmtd', ['eth0'])
    end
  end

  context 'when mgmtd_conn_net_filters => ["192.168.1.0/24"]' do
    let(:params) { { mgmtd: true, mgmtd_conn_net_filters: ['192.168.1.0/24'] } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-mgmtd.conf', [
                        'connNetFilterFile                      = /etc/beegfs/netfilter.mgmtd',
                      ])
    end

    it { is_expected.to contain_file('/etc/beegfs/netfilter.mgmtd').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/netfilter.mgmtd', ['192.168.1.0/24'])
    end
  end

  context 'when mgmtd_store_directory => "/beegfs/mgmtd"' do
    let(:params) { { mgmtd: true, mgmtd_store_directory: '/beegfs/mgmtd' } }

    it do
      is_expected.to contain_file('beegfs-storeMgmtdDirectory').with(ensure: 'directory',
                                                                     path: '/beegfs/mgmtd')
    end

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-mgmtd.conf', [
                        'storeMgmtdDirectory                    = /beegfs/mgmtd',
                      ])
    end
  end
end
