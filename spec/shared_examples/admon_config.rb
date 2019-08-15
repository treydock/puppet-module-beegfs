shared_context 'beegfs::admon::config' do
  it do
    is_expected.to contain_file('/etc/beegfs').with(ensure: 'directory',
                                                    owner: 'root',
                                                    group: 'root',
                                                    mode: '0755')
  end

  it do
    is_expected.to contain_file('/etc/beegfs/beegfs-admon.conf').with(ensure: 'present',
                                                                      owner: 'root',
                                                                      group: 'root',
                                                                      mode: '0644')
  end

  it do
    expected = [
      '# --- Section 1.1: [Basic Settings] ---',
      'sysMgmtdHost                 = ',
      '# --- Section 1.2: [Advanced Settings] ---',
      'clearDatabase                = false',
      'httpPort                     = 8000',
      'databaseFile                 = /var/lib/beegfs/beegfs-admon.db',
      'queryInterval                = 5',
      'connAdmonPortUDP             = 8007',
      'connMgmtdPortTCP             = 8008',
      'connMgmtdPortUDP             = 8008',
      'connPortShift                = 0',
      'connAuthFile                 = ',
      'connFallbackExpirationSecs   = 900',
      'connMaxInternodeNum          = 3',
      'connInterfacesFile           = ',
      'connNetFilterFile            = ',
      'connTcpOnlyFilterFile        = ',
      'logType                      = logfile',
      'logLevel                     = 3',
      'logNoDate                    = false',
      'logNumLines                  = 50000',
      'logNumRotatedFiles           = 2',
      'logStdFile                   = /var/log/beegfs-admon.log',
      'mailEnabled                  = false',
      'mailSmtpSendType             = socket',
      'mailSendmailPath             = sendmail',
      'mailCheckIntervalTimeSec     = 30',
      'mailMinDownTimeSec           = 10',
      'mailRecipient                = ',
      'mailResendMailTimeMin        = 60',
      'mailSender                   = ',
      'mailSmtpServer               = ',
      'runDaemonized                = true',
      'tuneNumWorkers               = 4',
    ]
    content = catalogue.resource('file', '/etc/beegfs/beegfs-admon.conf').send(:parameters)[:content]
    pp(expected - (content.split(%r{\n}).reject { |line| line =~ %r{(^#|^$)} } & expected))
    verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', expected)
  end

  it do
    is_expected.to contain_file('/etc/beegfs/interfaces.admon').with(ensure: 'absent',
                                                                     content: %r{^$},
                                                                     owner: 'root',
                                                                     group: 'root',
                                                                     mode: '0644')
  end

  it do
    is_expected.to contain_file('/etc/beegfs/netfilter.admon').with(ensure: 'absent',
                                                                    content: %r{^$},
                                                                    owner: 'root',
                                                                    group: 'root',
                                                                    mode: '0644')
  end

  it do
    is_expected.to contain_file('/etc/beegfs/tcp-only-filter').with(ensure: 'absent',
                                                                    content: %r{^$},
                                                                    owner: 'root',
                                                                    group: 'root',
                                                                    mode: '0644')
  end

  it do
    is_expected.to contain_file('/var/lib/beegfs').with(ensure: 'directory',
                                                        owner: 'root',
                                                        group: 'root',
                                                        mode: '0755')
  end

  context 'when admon_config_overrides defined' do
    let(:params) { { admon: true, admon_config_overrides: { 'tuneNumWorkers' => '8' } } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'tuneNumWorkers               = 8',
                      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) { { admon: true, conn_port_shift: 1000 } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'connPortShift                = 1000',
                      ])
    end
  end

  context 'when admon_conn_interfaces => ["eth0"]' do
    let(:params) { { admon: true, admon_conn_interfaces: ['eth0'] } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'connInterfacesFile           = /etc/beegfs/interfaces.admon',
                      ])
    end

    it { is_expected.to contain_file('/etc/beegfs/interfaces.admon').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/interfaces.admon', ['eth0'])
    end
  end

  context 'when admon_conn_net_filters => ["192.168.1.0/24"]' do
    let(:params) { { admon: true, admon_conn_net_filters: ['192.168.1.0/24'] } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'connNetFilterFile            = /etc/beegfs/netfilter.admon',
                      ])
    end

    it { is_expected.to contain_file('/etc/beegfs/netfilter.admon').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/beegfs/netfilter.admon', ['192.168.1.0/24'])
    end
  end

  context 'when conn_tcp_only_filters => ["192.168.1.0/24"]' do
    let(:params) { { admon: true, conn_tcp_only_filters: ['192.168.1.0/24', '10.0.0.0/8'] } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'connTcpOnlyFilterFile        = /etc/beegfs/tcp-only-filter',
                      ])
    end

    it do
      is_expected.to contain_file('/etc/beegfs/tcp-only-filter').with(ensure: 'present',
                                                                      content: "192.168.1.0/24\n10.0.0.0/8",
                                                                      owner: 'root',
                                                                      group: 'root',
                                                                      mode: '0644')
    end
  end

  context 'when admon_database_file_dir => "/beegfs"' do
    let(:params) { { admon: true, admon_database_file_dir: '/beegfs' } }

    it { is_expected.not_to contain_file('/var/lib/beegfs') }

    it do
      is_expected.to contain_file('/beegfs').with(ensure: 'directory',
                                                  owner: 'root',
                                                  group: 'root',
                                                  mode: '0755')
    end

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'databaseFile                 = /beegfs/beegfs-admon.db',
                      ])
    end
  end

  context 'when mgmtd_host => "mgmtd.foo"' do
    let(:params) { { admon: true, mgmtd_host: 'mgmtd.foo' } }

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
                        'sysMgmtdHost                 = mgmtd.foo',
                      ])
    end
  end
end
