shared_context 'fhgfs::storage::install' do
  it do
    should contain_package('fhgfs-storage').with({
      :ensure     => 'present',
      :name       => 'fhgfs-storage',
      :notify     => nil,
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :storage => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-storage').with_ensure('2012.10.r9') }
  end

  context 'when storage_service_autorestat => true' do
    let(:params) {{ :storage => true, :storage_service_autorestart => true }}
    it { should contain_package('fhgfs-storage').with_notify('Service[fhgfs-storage]') }
  end
end
