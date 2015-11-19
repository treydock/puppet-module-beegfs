shared_examples_for 'beegfs::mgmtd' do
  it { should create_class('beegfs::mgmtd') }

  it { should contain_anchor('beegfs::mgmtd::start').that_comes_before('Class[beegfs::repo]') }
  it { should contain_class('beegfs::repo').that_comes_before('Class[beegfs::mgmtd::install]') }
  it { should contain_class('beegfs::mgmtd::install').that_comes_before('Class[beegfs::mgmtd::config]') }
  it { should contain_class('beegfs::mgmtd::config').that_comes_before('Class[beegfs::mgmtd::service]') }
  it { should contain_class('beegfs::mgmtd::service').that_comes_before('Anchor[beegfs::mgmtd::end]') }
  it { should contain_anchor('beegfs::mgmtd::end') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::mgmtd::install'
  it_behaves_like 'beegfs::mgmtd::config'
  it_behaves_like 'beegfs::mgmtd::service'

end
