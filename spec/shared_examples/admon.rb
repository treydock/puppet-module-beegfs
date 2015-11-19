shared_examples_for 'beegfs::admon' do
  it { should create_class('beegfs::admon') }

  it { should contain_anchor('beegfs::admon::start').that_comes_before('Class[beegfs::repo]') }
  it { should contain_class('beegfs::repo').that_comes_before('Class[beegfs::admon::install]') }
  it { should contain_class('beegfs::admon::install').that_comes_before('Class[beegfs::admon::config]') }
  it { should contain_class('beegfs::admon::config').that_comes_before('Class[beegfs::admon::service]') }
  it { should contain_class('beegfs::admon::service').that_comes_before('Anchor[beegfs::admon::end]') }
  it { should contain_anchor('beegfs::admon::end') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::admon::install'
  it_behaves_like 'beegfs::admon::config'
  it_behaves_like 'beegfs::admon::service'

end
