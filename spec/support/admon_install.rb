shared_context 'fhgfs::admon::install' do
  it do
    should contain_package('fhgfs-admon').with({
      :ensure     => 'present',
      :name       => 'fhgfs-admon',
      :notify     => nil,
    })
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :admon => true, :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-admon').with_ensure('2012.10.r9') }
  end

  context 'when admon_service_autorestat => true' do
    let(:params) {{ :admon => true, :admon_service_autorestart => true }}
    it { should contain_package('fhgfs-admon').with_notify('Service[fhgfs-admon]') }
  end
end
