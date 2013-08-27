shared_examples_for 'role package' do
  it do
    should contain_package(package_name).with({
      'ensure'    => 'present',
      'name'      => package_name,
      'before'    => "File[/etc/fhgfs/#{package_name}.conf]",
      'require'   => 'Yumrepo[fhgfs]',
    })
  end
end
