shared_context 'fhgfs::storage::service' do

  it do
    should contain_service('fhgfs-storage').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'fhgfs-storage',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
    })
  end

  context 'with storage_service_ensure => "running"' do
    let(:params) {{ :storage => true, :storage_service_ensure => 'stopped' }}
    it { should contain_service('fhgfs-storage').with_ensure('stopped') }
  end

  context 'with storage_service_enable => false' do
    let(:params) {{ :storage => true, :storage_service_enable => false }}
    it { should contain_service('fhgfs-storage').with_enable('false') }
  end

  context 'with storage_service_autorestart => true' do
    let(:params) {{ :storage => true, :storage_service_autorestart => true }}
    it { should contain_service('fhgfs-storage').with_subscribe(['File[/etc/fhgfs/fhgfs-storage.conf]', 'File[/etc/fhgfs/interfaces.storage]']) }
  end

  context 'with storage_manage_service => false' do
    let(:params) {{ :storage => true, :storage_manage_service => false }}
    it { should_not contain_service('fhgfs-storage') }
  end
end
