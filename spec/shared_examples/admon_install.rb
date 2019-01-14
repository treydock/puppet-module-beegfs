shared_context 'beegfs::admon::install' do
  it do
    should contain_package('beegfs-admon').with({
      :ensure     => 'present',
      :name       => 'beegfs-admon',
      :notify     => nil,
    })
  end

  context "when version => '7.1.3'" do
    let(:params) {{ :admon => true, :version => '7.1.3' }}
    it { should contain_package('beegfs-admon').with_ensure('7.1.3') }
  end

  context 'when admon_service_autorestat => true' do
    let(:params) {{ :admon => true, :admon_service_autorestart => true }}
    it { should contain_package('beegfs-admon').with_notify('Service[beegfs-admon]') }
  end
end
