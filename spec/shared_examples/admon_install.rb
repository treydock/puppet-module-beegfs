shared_context 'beegfs::admon::install' do
  it do
    should contain_package('beegfs-admon').with({
      :ensure     => 'present',
      :name       => 'beegfs-admon',
      :notify     => nil,
    })
  end

  context "when version => '2015.03.r9'" do
    let(:params) {{ :admon => true, :version => '2015.03.r9' }}
    it { should contain_package('beegfs-admon').with_ensure('2015.03.r9') }
  end

  context 'when admon_service_autorestat => true' do
    let(:params) {{ :admon => true, :admon_service_autorestart => true }}
    it { should contain_package('beegfs-admon').with_notify('Service[beegfs-admon]') }
  end
end
