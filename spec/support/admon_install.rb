shared_context 'fhgfs::admon::install' do
  it do
    should contain_package('fhgfs-admon').with({
      :ensure     => 'present',
      :name       => 'fhgfs-admon',
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :admon => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-admon').with_ensure('2012.10.r9') }
  end
end
