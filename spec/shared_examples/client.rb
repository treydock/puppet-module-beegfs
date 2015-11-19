shared_examples_for 'beegfs::client' do
  it { should create_class('beegfs::client') }

  it { should contain_anchor('beegfs::client::start').that_comes_before('Class[beegfs::repo]') }
  it { should contain_class('beegfs::repo').that_comes_before('Class[beegfs::client::install]') }
  it { should contain_class('beegfs::client::install').that_comes_before('Class[beegfs::client::config]') }
  it { should contain_class('beegfs::client::config').that_comes_before('Class[beegfs::client::service]') }
  it { should contain_class('beegfs::client::service').that_comes_before('Anchor[beegfs::client::end]') }
  it { should contain_anchor('beegfs::client::end') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::client::install'
  it_behaves_like 'beegfs::client::config'
  it_behaves_like 'beegfs::client::service'

end