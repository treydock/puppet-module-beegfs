shared_examples_for 'beegfs::mgmtd::service' do
  it do
    is_expected.to contain_service('beegfs-mgmtd').only_with(ensure: 'running',
                                                             enable: 'true',
                                                             name: 'beegfs-mgmtd',
                                                             hasstatus: 'true',
                                                             hasrestart: 'true')
  end

  context 'with mgmtd_service_ensure => "running"' do
    let(:params) { { mgmtd: true, mgmtd_service_ensure: 'stopped' } }

    it { is_expected.to contain_service('beegfs-mgmtd').with_ensure('stopped') }
  end

  context 'with mgmtd_service_enable => false' do
    let(:params) { { mgmtd: true, mgmtd_service_enable: false } }

    it { is_expected.to contain_service('beegfs-mgmtd').with_enable('false') }
  end

  context 'with mgmtd_service_autorestart => true' do
    let(:params) { { mgmtd: true, mgmtd_service_autorestart: true } }

    it {
      is_expected.to contain_service('beegfs-mgmtd').with_subscribe([
                                                                      'File[/etc/beegfs/beegfs-mgmtd.conf]',
                                                                      'File[/etc/beegfs/interfaces.mgmtd]',
                                                                      'File[/etc/beegfs/netfilter.mgmtd]',
                                                                    ])
    }
  end

  context 'with mgmtd_manage_service => false' do
    let(:params) { { mgmtd: true, mgmtd_manage_service: false } }

    it { is_expected.not_to contain_service('beegfs-mgmtd') }
  end
end
