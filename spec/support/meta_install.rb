shared_context 'fhgfs::meta::install' do
  it do
    should contain_package('fhgfs-meta').with({
      :ensure     => 'present',
      :name       => 'fhgfs-meta',
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :meta => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-meta').with_ensure('2012.10.r9') }
  end
end
