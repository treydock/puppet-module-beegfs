shared_context 'beegfs::admon::service' do
  it do
    is_expected.to contain_service('beegfs-admon').only_with(ensure: 'running',
                                                             enable: 'true',
                                                             name: 'beegfs-admon',
                                                             hasstatus: 'true',
                                                             hasrestart: 'true')
  end

  context 'with admon_service_ensure => "running"' do
    let(:params) { { admon: true, admon_service_ensure: 'stopped' } }

    it { is_expected.to contain_service('beegfs-admon').with_ensure('stopped') }
  end

  context 'with admon_service_enable => false' do
    let(:params) { { admon: true, admon_service_enable: false } }

    it { is_expected.to contain_service('beegfs-admon').with_enable('false') }
  end

  context 'with admon_service_autorestart => true' do
    let(:params) { { admon: true, admon_service_autorestart: true } }

    it {
      is_expected.to contain_service('beegfs-admon').with_subscribe([
                                                                      'File[/etc/beegfs/beegfs-admon.conf]',
                                                                      'File[/etc/beegfs/interfaces.admon]',
                                                                      'File[/etc/beegfs/netfilter.admon]',
                                                                      'File[/etc/beegfs/tcp-only-filter]',
                                                                    ])
    }
  end

  context 'with admon_manage_service => false' do
    let(:params) { { admon: true, admon_manage_service: false } }

    it { is_expected.not_to contain_service('beegfs-admon') }
  end
end
