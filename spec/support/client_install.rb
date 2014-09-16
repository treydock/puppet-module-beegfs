shared_context 'fhgfs::client::install' do
  it do
    should contain_package('fhgfs-helperd').with({
      :ensure     => 'present',
      :name       => 'fhgfs-helperd',
      :require    => 'Yumrepo[fhgfs]',
    })
  end

  it do
    should contain_package('fhgfs-client').with({
      :ensure     => 'present',
      :name       => 'fhgfs-client',
      :require    => 'Yumrepo[fhgfs]',
    })
  end

  it do
    should contain_package('fhgfs-utils').with({
      :ensure     => 'present',
      :name       => 'fhgfs-utils',
      :require    => 'Yumrepo[fhgfs]',
    })
  end

  context "when fhgfs::package_version => '2012.10.r9'" do
    let(:pre_condition) { "class { 'fhgfs': package_version => '2012.10.r9' }" }
    it { should contain_package('fhgfs-helperd').with_ensure('2012.10.r9') }
    it { should contain_package('fhgfs-client').with_ensure('2012.10.r9') }
    it { should contain_package('fhgfs-utils').with_ensure('2012.10.r9') }
  end
end
