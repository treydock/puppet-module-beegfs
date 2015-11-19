shared_context 'beegfs::meta::service' do

  it do
    should contain_service('beegfs-meta').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'beegfs-meta',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
    })
  end

  context 'with meta_service_ensure => "running"' do
    let(:params) {{ :meta => true, :meta_service_ensure => 'stopped' }}
    it { should contain_service('beegfs-meta').with_ensure('stopped') }
  end

  context 'with meta_service_enable => false' do
    let(:params) {{ :meta => true, :meta_service_enable => false }}
    it { should contain_service('beegfs-meta').with_enable('false') }
  end

  context 'with meta_service_autorestart => true' do
    let(:params) {{ :meta => true, :meta_service_autorestart => true }}
    it { should contain_service('beegfs-meta').with_subscribe(['File[/etc/beegfs/beegfs-meta.conf]', 'File[/etc/beegfs/interfaces.meta]']) }
  end

  context 'with meta_manage_service => false' do
    let(:params) {{ :meta => true, :meta_manage_service => false }}
    it { should_not contain_service('beegfs-meta') }
  end
end
