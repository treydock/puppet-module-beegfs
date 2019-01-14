shared_examples_for 'beegfs::mgmtd::install' do
  it do
    should contain_package('beegfs-mgmtd').with({
      :ensure     => 'present',
      :name       => 'beegfs-mgmtd',
      :notify     => nil,
    })
  end

  context "when version => '7.1.3'" do
    let(:params) {{ :mgmtd => true, :version => '7.1.3' }}
    it { should contain_package('beegfs-mgmtd').with_ensure('7.1.3') }
  end

  context 'when mgmtd_service_autorestat => true' do
    let(:params) {{ :mgmtd => true, :mgmtd_service_autorestart => true }}
    it { should contain_package('beegfs-mgmtd').with_notify('Service[beegfs-mgmtd]') }
  end
end
