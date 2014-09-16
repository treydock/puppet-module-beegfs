shared_context 'fhgfs::mgmtd::service' do

  it do
    should contain_service('fhgfs-mgmtd').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'fhgfs-mgmtd',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
    })
  end

  context 'with service_ensure => "running"' do
    let(:params) {{ :service_ensure => 'stopped' }}
    it { should contain_service('fhgfs-mgmtd').with_ensure('stopped') }
  end

  context 'with service_enable => false' do
    let(:params) {{ :service_enable => false }}
    it { should contain_service('fhgfs-mgmtd').with_enable('false') }
  end

  context 'with service_autorestart => true' do
    let(:params) {{ :service_autorestart => true }}
    it { should contain_service('fhgfs-mgmtd').with_subscribe('File[/etc/fhgfs/fhgfs-mgmtd.conf]') }
  end

  context 'with service_autorestart => true and conn_interfaces => ["eth0"]' do
    let(:params) {{ :service_autorestart => true, :conn_interfaces => ["eth0"] }}
    it { should contain_service('fhgfs-mgmtd').with_subscribe(['File[/etc/fhgfs/fhgfs-mgmtd.conf]', 'File[/etc/fhgfs/interfaces.mgmtd]']) }
  end

  context 'with manage_service => false' do
    let(:params) {{ :manage_service => false }}
    it { should_not contain_service('fhgfs-mgmtd') }
  end
end
