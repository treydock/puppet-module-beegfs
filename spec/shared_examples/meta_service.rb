shared_context 'beegfs::meta::service' do
  it do
    is_expected.to contain_service('beegfs-meta').only_with(ensure: 'running',
                                                            enable: 'true',
                                                            name: 'beegfs-meta',
                                                            hasstatus: 'true',
                                                            hasrestart: 'true')
  end

  context 'with meta_service_ensure => "running"' do
    let(:params) { { meta: true, meta_service_ensure: 'stopped' } }

    it { is_expected.to contain_service('beegfs-meta').with_ensure('stopped') }
  end

  context 'with meta_service_enable => false' do
    let(:params) { { meta: true, meta_service_enable: false } }

    it { is_expected.to contain_service('beegfs-meta').with_enable('false') }
  end

  context 'with meta_service_autorestart => true' do
    let(:params) { { meta: true, meta_service_autorestart: true } }

    it {
      is_expected.to contain_service('beegfs-meta').with_subscribe([
                                                                     'File[/etc/beegfs/beegfs-meta.conf]',
                                                                     'File[/etc/beegfs/interfaces.meta]',
                                                                     'File[/etc/beegfs/netfilter.meta]',
                                                                     'File[/etc/beegfs/tcp-only-filter]',
                                                                   ])
    }
    context 'with_rdma => true' do
      let(:params) { { meta: true, meta_service_autorestart: true, with_rdma: true } }

      it {
        is_expected.to contain_service('beegfs-meta').with_subscribe([
                                                                       'File[/etc/beegfs/beegfs-meta.conf]',
                                                                       'File[/etc/beegfs/interfaces.meta]',
                                                                       'File[/etc/beegfs/netfilter.meta]',
                                                                       'File[/etc/beegfs/tcp-only-filter]',
                                                                       'Package[libbeegfs-ib]',
                                                                     ])
      }
    end
  end

  context 'with meta_manage_service => false' do
    let(:params) { { meta: true, meta_manage_service: false } }

    it { is_expected.not_to contain_service('beegfs-meta') }
  end
end
