shared_examples_for 'fhgfs::mgmtd' do
  it { should create_class('fhgfs::mgmtd') }

  it { should contain_anchor('fhgfs::mgmtd::start').that_comes_before('Class[fhgfs::repo]') }
  it { should contain_class('fhgfs::repo').that_comes_before('Class[fhgfs::mgmtd::install]') }
  it { should contain_class('fhgfs::mgmtd::install').that_comes_before('Class[fhgfs::mgmtd::config]') }
  it { should contain_class('fhgfs::mgmtd::config').that_comes_before('Class[fhgfs::mgmtd::service]') }
  it { should contain_class('fhgfs::mgmtd::service').that_comes_before('Anchor[fhgfs::mgmtd::end]') }
  it { should contain_anchor('fhgfs::mgmtd::end') }

  it_behaves_like 'fhgfs::repo'
  it_behaves_like 'fhgfs::mgmtd::install'
  it_behaves_like 'fhgfs::mgmtd::config'
  it_behaves_like 'fhgfs::mgmtd::service'

end
