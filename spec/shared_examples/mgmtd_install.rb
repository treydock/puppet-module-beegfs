shared_examples_for 'beegfs::mgmtd::install' do
  it do
    should contain_package('beegfs-mgmtd').with({
      :ensure     => 'present',
      :name       => 'beegfs-mgmtd',
      :notify     => nil,
    })
  end

  context "when version => '2015.03.r9'" do
    let(:params) {{ :mgmtd => true, :version => '2015.03.r9' }}
    it { should contain_package('beegfs-mgmtd').with_ensure('2015.03.r9') }
  end

  context 'when mgmtd_service_autorestat => true' do
    let(:params) {{ :mgmtd => true, :mgmtd_service_autorestart => true }}
    it { should contain_package('beegfs-mgmtd').with_notify('Service[beegfs-mgmtd]') }
  end
end
