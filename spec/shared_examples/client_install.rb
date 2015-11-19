shared_examples_for 'beegfs::client::install' do
  it { should contain_package('kernel-devel').with_ensure('present') }

  it do
    should contain_package('beegfs-helperd').with({
      :ensure     => 'present',
      :name       => 'beegfs-helperd',
      :notify     => 'Service[beegfs-helperd]',
    })
  end

  it do
    should contain_package('beegfs-client').with({
      :ensure     => 'present',
      :name       => 'beegfs-client',
      :notify     => 'Service[beegfs-client]'
    })
  end

  it do
    should contain_package('beegfs-client').that_requires('Package[kernel-devel]')
  end

  it do
    should contain_package('beegfs-utils').with({
      :ensure     => 'present',
      :name       => 'beegfs-utils',
    })
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}
    it { should_not contain_package('beegfs-helperd') }
    it { should_not contain_package('beegfs-client') }
    it { should contain_package('beegfs-utils') }
  end

  context "when version => '2015.03.r9'" do
    let(:params) {{ :version => '2015.03.r9' }}
    it { should contain_package('beegfs-helperd').with_ensure('2015.03.r9') }
    it { should contain_package('beegfs-client').with_ensure('2015.03.r9') }
    it { should contain_package('beegfs-utils').with_ensure('2015.03.r9') }
  end

  context 'when client_service_autorestart => false' do
    let(:params) {{ :client_service_autorestart => false }}
    it { should contain_package('beegfs-helperd').without_notify }
    it { should contain_package('beegfs-client').without_notify }
  end

  context 'when manage_client_dependencies => false' do
    let(:params) {{ :manage_client_dependencies => false }}
    it { should_not contain_package('kernel-devel') }
  end
end
