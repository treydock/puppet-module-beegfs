shared_context 'fhgfs::storage::install' do
  it do
    should contain_package('fhgfs-storage').with({
      :ensure     => 'present',
      :name       => 'fhgfs-storage',
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :storage => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-storage').with_ensure('2012.10.r9') }
  end
end
