shared_context 'fhgfs::storage::install' do
  it do
    should contain_package('fhgfs-storage').with({
      :ensure     => 'present',
      :name       => 'fhgfs-storage',
      :require    => 'Yumrepo[fhgfs]',
    })
  end

  context "when fhgfs::package_version => '2012.10.r9'" do
    let(:pre_condition) { "class { 'fhgfs': package_version => '2012.10.r9' }" }
    it { should contain_package('fhgfs-storage').with_ensure('2012.10.r9') }
  end
end
