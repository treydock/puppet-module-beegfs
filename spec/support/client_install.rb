shared_examples_for 'fhgfs::client::install' do
  it do
    should contain_package('fhgfs-helperd').with({
      :ensure     => 'present',
      :name       => 'fhgfs-helperd',
    })
  end

  it do
    should contain_package('fhgfs-client').with({
      :ensure     => 'present',
      :name       => 'fhgfs-client',
    })
  end

  it do
    should contain_package('fhgfs-utils').with({
      :ensure     => 'present',
      :name       => 'fhgfs-utils',
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-helperd').with_ensure('2012.10.r9') }
    it { should contain_package('fhgfs-client').with_ensure('2012.10.r9') }
    it { should contain_package('fhgfs-utils').with_ensure('2012.10.r9') }
  end
end
