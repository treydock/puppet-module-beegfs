shared_context 'beegfs::storage::service' do
  it do
    is_expected.to contain_service('beegfs-storage').only_with(ensure: 'running',
                                                               enable: 'true',
                                                               name: 'beegfs-storage',
                                                               hasstatus: 'true',
                                                               hasrestart: 'true')
  end

  context 'with storage_service_ensure => "running"' do
    let(:params) { { storage: true, storage_service_ensure: 'stopped' } }

    it { is_expected.to contain_service('beegfs-storage').with_ensure('stopped') }
  end

  context 'with storage_service_enable => false' do
    let(:params) { { storage: true, storage_service_enable: false } }

    it { is_expected.to contain_service('beegfs-storage').with_enable('false') }
  end

  context 'with storage_service_autorestart => true' do
    let(:params) { { storage: true, storage_service_autorestart: true } }

    it {
      is_expected.to contain_service('beegfs-storage').with_subscribe([
                                                                        'File[/etc/beegfs/beegfs-storage.conf]',
                                                                        'File[/etc/beegfs/interfaces.storage]',
                                                                        'File[/etc/beegfs/netfilter.storage]',
                                                                        'File[/etc/beegfs/tcp-only-filter]',
                                                                      ])
    }
    context 'with_rdma => true' do
      let(:params) { { storage: true, storage_service_autorestart: true, with_rdma: true } }

      it {
        is_expected.to contain_service('beegfs-storage').with_subscribe([
                                                                          'File[/etc/beegfs/beegfs-storage.conf]',
                                                                          'File[/etc/beegfs/interfaces.storage]',
                                                                          'File[/etc/beegfs/netfilter.storage]',
                                                                          'File[/etc/beegfs/tcp-only-filter]',
                                                                          'Package[libbeegfs-ib]',
                                                                        ])
      }
    end
  end

  context 'with storage_manage_service => false' do
    let(:params) { { storage: true, storage_manage_service: false } }

    it { is_expected.not_to contain_service('beegfs-storage') }
  end
end
