shared_examples_for 'role package' do
  it do
    should contain_package(package_name).with({
      'ensure'    => 'present',
      'name'      => package_name,
      'before'    => "File[/etc/fhgfs/#{package_name}.conf]",
      'require'   => 'Yumrepo[fhgfs]',
    })
  end

  context "when package_ensure => '2012.10.r9'" do
    let(:params) {{ :package_ensure => '2012.10.r9' }}
    it { should contain_package(package_name).with_ensure('2012.10.r9') }
  end

  context "when fhgfs::package_ensure => '2012.10.r9'" do
    let(:pre_condition) { "class { 'fhgfs': package_ensure => '2012.10.r9' }" }
    it { should contain_package(package_name).with_ensure('2012.10.r9') }
  end
end
