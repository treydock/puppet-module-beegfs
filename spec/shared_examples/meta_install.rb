shared_context 'beegfs::meta::install' do
  it do
    should contain_package('beegfs-meta').with({
      :ensure     => 'present',
      :name       => 'beegfs-meta',
      :notify     => nil,
    })
  end

  context "when version => '7.1.3'" do
    let(:params) {{ :meta => true, :version => '7.1.3' }}
    it { should contain_package('beegfs-meta').with_ensure('7.1.3') }
  end

  context 'when meta_service_autorestat => true' do
    let(:params) {{ :meta => true, :meta_service_autorestart => true }}
    it { should contain_package('beegfs-meta').with_notify('Service[beegfs-meta]') }
  end
end
