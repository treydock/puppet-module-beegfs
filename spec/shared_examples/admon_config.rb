shared_context 'beegfs::admon::config' do
  it do
    should contain_file('/etc/beegfs/beegfs-admon.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
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
      'connNetFilterFile            = ',
      'logLevel                     = 2',
      'logNoDate                    = false',
      'logNumLines                  = 50000',
      'logNumRotatedFiles           = 2',
      'logStdFile                   = /var/log/beegfs-admon.log',
      'mailEnabled                  = false',
      'mailCheckIntervalTimeSec     = 30',
      'mailMinDownTimeSec           = 10',
      'mailRecipient                = ',
      'mailResendMailTimeMin        = 60',
      'mailSender                   = ',
      'mailSmtpServer               = ',
      'runDaemonized                = true',
      'tuneNumWorkers               = 4',
    ])
  end

  it do
    should contain_file('/var/lib/beegfs').with({
      :ensure   => 'directory',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0755',
    })
  end

  context 'when admon_config_overrides defined' do
    let(:params) {{ :admon => true, :admon_config_overrides => {'tuneNumWorkers'  => '8' } }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
        'tuneNumWorkers               = 8',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :admon => true, :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
        'connPortShift                = 1000',
      ])
    end
  end

  context 'when admon_database_file_dir => "/beegfs"' do
    let(:params) {{ :admon => true, :admon_database_file_dir => "/beegfs" }}

    it { should_not contain_file('/var/lib/beegfs') }

    it do
      should contain_file('/beegfs').with({
        :ensure => 'directory',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0755',
      })
    end

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
        'databaseFile                 = /beegfs/beegfs-admon.db',
      ])
    end
  end

  context 'when mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :admon => true, :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/beegfs/beegfs-admon.conf', [
        'sysMgmtdHost                 = mgmtd.foo',
      ])
    end
  end
end
