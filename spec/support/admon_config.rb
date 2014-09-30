shared_context 'fhgfs::admon::config' do
  it do
    should contain_file('/etc/fhgfs/fhgfs-admon.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-admon.conf', [
      'logLevel                 = 2',
      'logNoDate                = false',
      'logStdFile               = /var/log/fhgfs-admon.log',
      'logNumLines              = 50000',
      'logNumRotatedFiles       = 2',
      'connPortShift            = 0',
      'connMgmtdPortUDP         = 8008',
      'connMgmtdPortTCP         = 8008',
      'connAdmonPortUDP         = 8007',
      'connMaxInternodeNum      = 3',
      'connNetFilterFile        = ',
      'connNonPrimaryExpiration = 10000',
      'tuneNumWorkers           = 4',
      'sysMgmtdHost             = ',
      'runDaemonized            = true',
      'httpPort                 = 8000',
      'queryInterval            = 5',
      'databaseFile             = /var/lib/fhgfs/fhgfs-admon.db',
      'clearDatabase            = false',
      'mailEnabled              = false',
      'mailSmtpServer           = ',
      'mailSender               = ',
      'mailRecipient            = ',
      'mailMinDownTimeSec       = 10',
      'mailResendMailTimeMin    = 60',
      'mailCheckIntervalTimeSec = 30',
    ])
  end

  it do
    should contain_file('/var/lib/fhgfs').with({
      :ensure   => 'directory',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0755',
    })
  end

  context 'when admon_config_overrides defined' do
    let(:params) {{ :admon => true, :admon_config_overrides => {'tuneNumWorkers'  => '8' } }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-admon.conf', [
        'tuneNumWorkers           = 8',
      ])
    end
  end

  context 'when conn_port_shift => 1000' do
    let(:params) {{ :admon => true, :conn_port_shift => 1000 }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-admon.conf', [
        'connPortShift            = 1000',
      ])
    end
  end

  context 'when admon_database_file_dir => "/fhgfs"' do
    let(:params) {{ :admon => true, :admon_database_file_dir => "/fhgfs" }}

    it { should_not contain_file('/var/lib/fhgfs') }

    it do
      should contain_file('/fhgfs').with({
        :ensure => 'directory',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0755',
      })
    end

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-admon.conf', [
        'databaseFile             = /fhgfs/fhgfs-admon.db',
      ])
    end
  end

  context 'when mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :admon => true, :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-admon.conf', [
        'sysMgmtdHost             = mgmtd.foo',
      ])
    end
  end

  context 'when release => "2014.01"' do
    let(:params) {{ :admon => true, :release => '2014.01' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-admon.conf', [
        'sysMgmtdHost                 = ',
        '# --- Section 1.2: [Advanced Settings] ---',
        'logLevel                     = 2',
        'logNoDate                    = false',
        'logStdFile                   = /var/log/fhgfs-admon.log',
        'logNumLines                  = 50000',
        'logNumRotatedFiles           = 2',
        'connPortShift                = 0',
        'connMgmtdPortUDP             = 8008',
        'connMgmtdPortTCP             = 8008',
        'connAdmonPortUDP             = 8007',
        'connMaxInternodeNum          = 3',
        'connNetFilterFile            = ',
        'connFallbackExpirationSecs   = 900',
        'connAuthFile                 = ',
        'tuneNumWorkers               = 4',
        'runDaemonized                = true',
        'httpPort                     = 8000',
        'queryInterval                = 5',
        'databaseFile                 = /var/lib/fhgfs/fhgfs-admon.db',
        'clearDatabase                = false',
        'mailEnabled                  = false',
        'mailSmtpServer               = ',
        'mailSender                   = ',
        'mailRecipient                = ',
        'mailMinDownTimeSec           = 10',
        'mailResendMailTimeMin        = 60',
        'mailCheckIntervalTimeSec     = 30',
      ])
    end
  end
end
