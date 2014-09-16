shared_examples_for 'fhgfs::mgmtd::service' do

  it do
    should contain_service('fhgfs-mgmtd').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'fhgfs-mgmtd',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
    })
  end

  context 'with mgmtd_service_ensure => "running"' do
    let(:params) {{ :mgmtd => true, :mgmtd_service_ensure => 'stopped' }}
    it { should contain_service('fhgfs-mgmtd').with_ensure('stopped') }
  end

  context 'with mgmtd_service_enable => false' do
    let(:params) {{ :mgmtd => true, :mgmtd_service_enable => false }}
    it { should contain_service('fhgfs-mgmtd').with_enable('false') }
  end

  context 'with mgmtd_service_autorestart => true' do
    let(:params) {{ :mgmtd => true, :mgmtd_service_autorestart => true }}
    it { should contain_service('fhgfs-mgmtd').with_subscribe(['File[/etc/fhgfs/fhgfs-mgmtd.conf]', 'File[/etc/fhgfs/interfaces.mgmtd]']) }
  end

  context 'with mgmtd_manage_service => false' do
    let(:params) {{ :mgmtd => true, :mgmtd_manage_service => false }}
    it { should_not contain_service('fhgfs-mgmtd') }
  end
end
