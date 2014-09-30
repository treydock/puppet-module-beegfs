shared_context 'fhgfs::meta::config' do
  it do
    should contain_file('/etc/fhgfs/fhgfs-meta.conf').with({
      :ensure   => 'present',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/fhgfs/fhgfs-meta.conf', [
      'logLevel                  = 3',
      'logNoDate                 = false',
      'logStdFile                = /var/log/fhgfs-meta.log',
      'logNumLines               = 50000',
      'logNumRotatedFiles        = 5',
      'connPortShift             = 0',
      'connMgmtdPortUDP          = 8008',
      'connMgmtdPortTCP          = 8008',
      'connMetaPortUDP           = 8005',
      'connMetaPortTCP           = 8005',
      'connUseSDP                = false',
      'connUseRDMA               = true',
      'connRDMATypeOfService     = 0',
      'connBacklogTCP            = 128',
      'connMaxInternodeNum       = 10',
      'connInterfacesFile        = ',
      'connNetFilterFile         = ',
      'connNonPrimaryExpiration  = 10000',
      'storeMetaDirectory        = ',
      'storeAllowFirstRunInit    = true',
      'storeUseExtendedAttribs   = true',
      'tuneNumWorkers            = 0',
      'tuneBindToNumaZone        = ',
      'tuneTargetChooser         = randomized',
      'tuneRotateMirrorTargets   = false',
      'tuneUsePerUserMsgQueues   = false',
      'sysMgmtdHost              = ',
      'runDaemonized             = true',
    ])
  end

  it do
    should contain_file('/etc/fhgfs/interfaces.meta').with({
      :ensure   => 'absent',
      :content  => /^$/,
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  context 'when meta_config_overrides defined' do
    let(:params) {{ :meta => true, :meta_config_overrides => {'tuneNumWorkers'  => '8' } }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-meta.conf', [
        'tuneNumWorkers            = 8',
      ])
    end
  end

  context 'when meta_conn_interfaces => ["eth0"]' do
    let(:params) {{ :meta => true, :meta_conn_interfaces => ["eth0"] }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-meta.conf', [
        'connInterfacesFile        = /etc/fhgfs/interfaces.meta',
      ])
    end

    it { should contain_file('/etc/fhgfs/interfaces.meta').with_ensure('present') }

    it do
      verify_contents(catalogue, '/etc/fhgfs/interfaces.meta', ['eth0'])
    end
  end

  context 'when meta_store_directory => "/fhgfs/meta"' do
    let(:params) {{ :meta => true, :meta_store_directory => "/fhgfs/meta" }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-meta.conf', [
        'storeMetaDirectory        = /fhgfs/meta',
      ])
    end
  end

  context 'when mgmtd_host => "mgmtd.foo"' do
    let(:params) {{ :meta => true, :mgmtd_host => 'mgmtd.foo' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-meta.conf', [
        'sysMgmtdHost              = mgmtd.foo',
      ])
    end
  end

  context 'when release => "2014.01"' do
    let(:params) {{ :meta => true, :release => '2014.01' }}

    it do
      verify_contents(catalogue, '/etc/fhgfs/fhgfs-meta.conf', [
        'sysMgmtdHost                 = ',
        'storeMetaDirectory           = ',
        'storeAllowFirstRunInit       = true',
        '# --- Section 1.2: [Advanced Settings] ---',
        'logLevel                     = 3',
        'logNoDate                    = false',
        'logStdFile                   = /var/log/fhgfs-meta.log',
        'logNumLines                  = 50000',
        'logNumRotatedFiles           = 5',
        'connPortShift                = 0',
        'connMgmtdPortUDP             = 8008',
        'connMgmtdPortTCP             = 8008',
        'connMetaPortUDP              = 8005',
        'connMetaPortTCP              = 8005',
        'connUseSDP                   = false',
        'connUseRDMA                  = true',
        'connRDMATypeOfService        = 0',
        'connBacklogTCP               = 128',
        'connMaxInternodeNum          = 10',
        'connInterfacesFile           = ',
        'connNetFilterFile            = ',
        'connFallbackExpirationSecs   = 900',
        'connAuthFile                 = ',
        'storeUseExtendedAttribs      = true',
        'tuneNumWorkers               = 0',
        'tuneBindToNumaZone           = ',
        'tuneTargetChooser            = randomized',
        'tuneRotateMirrorTargets      = false',
        'tuneUsePerUserMsgQueues      = false',
        'runDaemonized                = true',
      ])
    end
  end
end
