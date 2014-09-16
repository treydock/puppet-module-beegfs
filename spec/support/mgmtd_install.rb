shared_examples_for 'fhgfs::mgmtd::install' do
  it do
    should contain_package('fhgfs-mgmtd').with({
      :ensure     => 'present',
      :name       => 'fhgfs-mgmtd',
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :mgmtd => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-mgmtd').with_ensure('2012.10.r9') }
  end
end
