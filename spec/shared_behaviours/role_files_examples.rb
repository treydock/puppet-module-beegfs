shared_examples_for 'role files' do
  it do
    should contain_file('/etc/fhgfs').with({
      'ensure'  => 'directory',
    })
  end

  it do
    should contain_file("/etc/fhgfs/#{name}.conf").with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'before'  => "Service[#{name}]",
    })
  end

  context 'with manage_service => false' do
    let(:params) {{ :manage_service => false }}
    it { should contain_file("/etc/fhgfs/#{name}.conf").with_before(nil) }
  end
end
