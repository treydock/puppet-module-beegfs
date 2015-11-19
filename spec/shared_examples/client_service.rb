shared_examples_for 'beegfs::client::service' do

  it do
    should contain_service('beegfs-helperd').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'beegfs-helperd',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
      :before       => 'Service[beegfs-client]',
      :subscribe    => 'File[/etc/beegfs/beegfs-helperd.conf]',
    })
  end

  it do
    should contain_service('beegfs-client').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'beegfs-client',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
      :subscribe    => [
        'File[/etc/beegfs/beegfs-client.conf]',
        'File[/etc/beegfs/beegfs-mounts.conf]',
        'File[/etc/beegfs/beegfs-client-autobuild.conf]',
        'File[/etc/beegfs/interfaces.client]',
        'File[/etc/beegfs/netfilter.client]',
      ],
    })
  end

  context 'with client_service_ensure => "running"' do
    let(:params) {{ :client_service_ensure => 'stopped' }}
    it { should contain_service('beegfs-helperd').with_ensure('stopped') }
    it { should contain_service('beegfs-client').with_ensure('stopped') }
  end

  context 'with client_service_enable => false' do
    let(:params) {{ :client_service_enable => false }}
    it { should contain_service('beegfs-helperd').with_enable('false') }
    it { should contain_service('beegfs-client').with_enable('false') }
  end

  context 'with client_service_autorestart => false' do
    let(:params) {{ :client_service_autorestart => false }}
    it { should contain_service('beegfs-helperd').without_subscribe }
    it { should contain_service('beegfs-client').without_subscribe }
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}

    it do
      should contain_service('beegfs-helperd').only_with({
        :ensure       => 'stopped',
        :enable       => 'false',
        :name         => 'beegfs-helperd',
        :hasstatus    => 'true',
        :hasrestart   => 'true',
        :before       => 'Service[beegfs-client]',
      })
    end

    it do
      should contain_service('beegfs-client').only_with({
        :ensure       => 'stopped',
        :enable       => 'false',
        :name         => 'beegfs-client',
        :hasstatus    => 'true',
        :hasrestart   => 'true',
      })
    end
  end

  context 'with client_manage_service => false' do
    let(:params) {{ :client_manage_service => false }}
    it { should_not contain_service('beegfs-helperd') }
    it { should_not contain_service('beegfs-client') }
  end
end
