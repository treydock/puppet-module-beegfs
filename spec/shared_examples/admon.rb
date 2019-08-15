shared_examples_for 'beegfs::admon' do
  it { is_expected.to create_class('beegfs::admon') }

  it { is_expected.to contain_class('beegfs::repo').that_comes_before('Class[beegfs::admon::install]') }
  it { is_expected.to contain_class('beegfs::admon::install').that_comes_before('Class[beegfs::admon::config]') }
  it { is_expected.to contain_class('beegfs::admon::config').that_comes_before('Class[beegfs::admon::service]') }
  it { is_expected.to contain_class('beegfs::admon::service') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::admon::install'
  it_behaves_like 'beegfs::admon::config'
  it_behaves_like 'beegfs::admon::service'
end
