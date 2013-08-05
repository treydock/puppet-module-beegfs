shared_examples_for 'server files' do
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
    })
  end
end
