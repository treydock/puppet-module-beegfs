shared_context 'beegfs::storage::install' do
  it do
    should contain_package('beegfs-storage').with({
      :ensure     => 'present',
      :name       => 'beegfs-storage',
      :notify     => nil,
    })
  end

  context "when version => '2015.03.r9'" do
    let(:params) {{ :storage => true, :version => '2015.03.r9' }}
    it { should contain_package('beegfs-storage').with_ensure('2015.03.r9') }
  end

  context 'when storage_service_autorestat => true' do
    let(:params) {{ :storage => true, :storage_service_autorestart => true }}
    it { should contain_package('beegfs-storage').with_notify('Service[beegfs-storage]') }
  end
end
