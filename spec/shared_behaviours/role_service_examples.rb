shared_examples_for 'role service' do
  it do
    should contain_service(service_name).with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => service_name,
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'subscribe'   => "File[/etc/fhgfs/#{service_name}.conf]",
    })
  end

  context 'with service_ensure => undef' do
    let(:params) {{ :service_ensure => 'undef' }}

    it do
      should contain_service(service_name).without_ensure
    end
  end

  context 'with service_enable => false' do
    let(:params) {{ :service_enable => false }}

    it do
      should contain_service(service_name).with_enable(false)
    end
  end

  context 'with service_enable => "false"' do
    let(:params) {{ :service_enable => "false" }}

    it do
      should contain_service(service_name).with_enable("false")
    end
  end

  context 'with service_enable => "undef"' do
    let(:params) {{ :service_enable => "undef" }}

    it do
      should contain_service(service_name).without_enable
    end
  end
end
