shared_examples_for 'fhgfs::client::install' do
  it do
    should contain_package('fhgfs-helperd').with({
      :ensure     => 'present',
      :name       => 'fhgfs-helperd',
      :notify     => 'Service[fhgfs-helperd]',
    })
  end

  it do
    should contain_package('fhgfs-client').with({
      :ensure     => 'present',
      :name       => 'fhgfs-client',
      :notify     => 'Service[fhgfs-client]'
    })
  end

  it do
    should contain_package('fhgfs-utils').with({
      :ensure     => 'present',
      :name       => 'fhgfs-utils',
    })
  end

  context 'when utils_only => true' do
    let(:params) {{ :utils_only => true }}
    it { should_not contain_package('fhgfs-helperd') }
    it { should_not contain_package('fhgfs-client') }
    it { should contain_package('fhgfs-utils') }
  end

  context "when version => '2012.10.r9'" do
    let(:params) {{ :version => '2012.10.r9' }}
    it { should contain_package('fhgfs-helperd').with_ensure('2012.10.r9') }
    it { should contain_package('fhgfs-client').with_ensure('2012.10.r9') }
    it { should contain_package('fhgfs-utils').with_ensure('2012.10.r9') }
  end

  context 'when client_service_autorestart => false' do
    let(:params) {{ :client_service_autorestart => false }}
    it { should contain_package('fhgfs-helperd').without_notify }
    it { should contain_package('fhgfs-client').without_notify }
  end
end
