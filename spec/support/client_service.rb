shared_examples_for 'fhgfs::client::service' do

  it do
    should contain_service('fhgfs-helperd').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'fhgfs-helperd',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
      :before       => 'Service[fhgfs-client]',
      :subscribe    => 'File[/etc/fhgfs/fhgfs-helperd.conf]',
    })
  end

  it do
    should contain_service('fhgfs-client').only_with({
      :ensure       => 'running',
      :enable       => 'true',
      :name         => 'fhgfs-client',
      :hasstatus    => 'true',
      :hasrestart   => 'true',
      :subscribe    => [
        'File[/etc/fhgfs/fhgfs-client.conf]',
        'File[/etc/fhgfs/fhgfs-mounts.conf]',
        'File[/etc/fhgfs/fhgfs-client-autobuild.conf]',
        'File[/etc/fhgfs/interfaces.client]',
        'File[/etc/fhgfs/netfilter.client]',
      ],
    })
  end

  context 'with client_service_ensure => "running"' do
    let(:params) {{ :client_service_ensure => 'stopped' }}
    it { should contain_service('fhgfs-helperd').with_ensure('stopped') }
    it { should contain_service('fhgfs-client').with_ensure('stopped') }
  end

  context 'with client_service_enable => false' do
    let(:params) {{ :client_service_enable => false }}
    it { should contain_service('fhgfs-helperd').with_enable('false') }
    it { should contain_service('fhgfs-client').with_enable('false') }
  end

  context 'with client_service_autorestart => false' do
    let(:params) {{ :client_service_autorestart => false }}
    it { should contain_service('fhgfs-helperd').without_subscribe }
    it { should contain_service('fhgfs-client').without_subscribe }
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}

    it do
      should contain_service('fhgfs-helperd').only_with({
        :ensure       => 'stopped',
        :enable       => 'false',
        :name         => 'fhgfs-helperd',
        :hasstatus    => 'true',
        :hasrestart   => 'true',
        :before       => 'Service[fhgfs-client]',
      })
    end

    it do
      should contain_service('fhgfs-client').only_with({
        :ensure       => 'stopped',
        :enable       => 'false',
        :name         => 'fhgfs-client',
        :hasstatus    => 'true',
        :hasrestart   => 'true',
      })
    end
  end

  context 'with client_manage_service => false' do
    let(:params) {{ :client_manage_service => false }}
    it { should_not contain_service('fhgfs-helperd') }
    it { should_not contain_service('fhgfs-client') }
  end
end
