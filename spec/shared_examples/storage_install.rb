shared_context 'beegfs::storage::install' do
  it do
    should contain_package('beegfs-storage').with({
      :ensure     => 'present',
      :name       => 'beegfs-storage',
      :notify     => nil,
    })
  end

  context "when version => '7.1.3'" do
    let(:params) {{ :storage => true, :version => '7.1.3' }}
    it { should contain_package('beegfs-storage').with_ensure('7.1.3') }
  end

  context 'when storage_service_autorestat => true' do
    let(:params) {{ :storage => true, :storage_service_autorestart => true }}
    it { should contain_package('beegfs-storage').with_notify('Service[beegfs-storage]') }
  end
end
