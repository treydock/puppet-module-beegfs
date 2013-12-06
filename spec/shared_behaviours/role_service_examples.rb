shared_examples_for 'role service' do

  it do
    should contain_service(service_name).with({
      'ensure'      => nil,
      'enable'      => nil,
      'name'        => service_name,
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'subscribe'   => nil,
    })
  end

  # Test service ensure and enable 'magic' values
  [
    'undef',
    'UNSET',
  ].each do |v|
    context "with service_ensure => '#{v}'" do
      let(:params) {{ :service_ensure => v }}
      it { should contain_service(service_name).with_ensure(nil) }
    end

    context "with service_enable => '#{v}'" do
      let(:params) {{ :service_enable => v }}
      it { should contain_service(service_name).with_enable(nil) }
    end
  end

  context 'with service_ensure => "running"' do
    let(:params) {{ :manage_service => true, :service_ensure => 'running' }}
    it { should contain_service(service_name).with_ensure('running') }
  end

  context 'with service_enable => true' do
    let(:params) {{ :manage_service => true, :service_enable => true }}
    it { should contain_service(service_name).with_enable('true') }
  end

  context 'with service_enable => false' do
    let(:params) {{ :manage_service => true, :service_enable => false }}
    it { should contain_service(service_name).with_enable('false') }
  end

  context 'with service_autorestart => true' do
    let(:params) {{ :manage_service => true, :service_autorestart => true }}
    it { should contain_service(service_name).with_subscribe("File[/etc/fhgfs/#{service_name}.conf]") }
  end

  context 'with service_autorestart => "true"' do
    let(:params) {{ :manage_service => true, :service_autorestart => 'true' }}
    it { expect { should contain_service(service_name) }.to raise_error(Puppet::Error, /is not a boolean/) }
  end

  context 'with manage_service => false' do
    let(:params) {{ :manage_service => false }}
    it { should_not contain_service(service_name) }
  end
end
