shared_context 'fhgfs::admon::service' do

  it do
    should contain_service('fhgfs-admon').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'fhgfs-admon',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
    })
  end

  context 'with service_ensure => "running"' do
    let(:params) {{ :service_ensure => 'stopped' }}
    it { should contain_service('fhgfs-admon').with_ensure('stopped') }
  end

  context 'with service_enable => false' do
    let(:params) {{ :service_enable => false }}
    it { should contain_service('fhgfs-admon').with_enable('false') }
  end

  context 'with service_autorestart => true' do
    let(:params) {{ :service_autorestart => true }}
    it { should contain_service('fhgfs-admon').with_subscribe('File[/etc/fhgfs/fhgfs-admon.conf]') }
  end

  context 'with manage_service => false' do
    let(:params) {{ :manage_service => false }}
    it { should_not contain_service('fhgfs-admon') }
  end
end
