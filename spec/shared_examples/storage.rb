shared_examples_for 'beegfs::storage' do
  it { is_expected.to create_class('beegfs::storage') }

  it { is_expected.to contain_class('beegfs::repo').that_comes_before('Class[beegfs::install]') }
  it { is_expected.to contain_class('beegfs::install').that_comes_before('Class[beegfs::storage::install]') }
  it { is_expected.to contain_class('beegfs::storage::install').that_comes_before('Class[beegfs::storage::config]') }
  it { is_expected.to contain_class('beegfs::storage::config').that_comes_before('Class[beegfs::storage::service]') }
  it { is_expected.to contain_class('beegfs::storage::service') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::install'
  it_behaves_like 'beegfs::storage::install'
  it_behaves_like 'beegfs::storage::config'
  it_behaves_like 'beegfs::storage::service'
end
