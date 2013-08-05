shared_examples_for 'server package' do
  it do
    should contain_package(package_name).with({
      'ensure'    => 'present',
      'name'      => package_name,
      'before'    => "File[/etc/fhgfs/#{package_name}.conf]",
      'require'   => 'Yumrepo[fhgfs]',
    })
  end
end
