shared_context 'beegfs::meta::install' do
  it do
    should contain_package('beegfs-meta').with({
      :ensure     => 'present',
      :name       => 'beegfs-meta',
      :notify     => nil,
    })
  end

  context "when version => '2015.03.r9'" do
    let(:params) {{ :meta => true, :version => '2015.03.r9' }}
    it { should contain_package('beegfs-meta').with_ensure('2015.03.r9') }
  end

  context 'when meta_service_autorestat => true' do
    let(:params) {{ :meta => true, :meta_service_autorestart => true }}
    it { should contain_package('beegfs-meta').with_notify('Service[beegfs-meta]') }
  end
end
