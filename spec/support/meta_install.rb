shared_context 'fhgfs::meta::install' do
  it do
    should contain_package('fhgfs-meta').with({
      :ensure     => 'present',
      :name       => 'fhgfs-meta',
      :notify     => nil,
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :meta => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-meta').with_ensure('2012.10.r9') }
  end

  context 'when meta_service_autorestat => true' do
    let(:params) {{ :meta => true, :meta_service_autorestart => true }}
    it { should contain_package('fhgfs-meta').with_notify('Service[fhgfs-meta]') }
  end
end
