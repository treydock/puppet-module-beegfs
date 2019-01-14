shared_examples_for 'beegfs::meta' do
  it { should create_class('beegfs::meta') }

  it { should contain_class('beegfs::repo').that_comes_before('Class[beegfs::install]') }
  it { should contain_class('beegfs::install').that_comes_before('Class[beegfs::meta::install]') }
  it { should contain_class('beegfs::meta::install').that_comes_before('Class[beegfs::meta::config]') }
  it { should contain_class('beegfs::meta::config').that_comes_before('Class[beegfs::meta::service]') }
  it { should contain_class('beegfs::meta::service') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::install'
  it_behaves_like 'beegfs::meta::install'
  it_behaves_like 'beegfs::meta::config'
  it_behaves_like 'beegfs::meta::service'

end
