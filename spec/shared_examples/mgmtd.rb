shared_examples_for 'beegfs::mgmtd' do
  it { is_expected.to create_class('beegfs::mgmtd') }

  it { is_expected.to contain_class('beegfs::repo').that_comes_before('Class[beegfs::mgmtd::install]') }
  it { is_expected.to contain_class('beegfs::mgmtd::install').that_comes_before('Class[beegfs::mgmtd::config]') }
  it { is_expected.to contain_class('beegfs::mgmtd::config').that_comes_before('Class[beegfs::mgmtd::service]') }
  it { is_expected.to contain_class('beegfs::mgmtd::service') }

  it_behaves_like 'beegfs::repo'
  it_behaves_like 'beegfs::mgmtd::install'
  it_behaves_like 'beegfs::mgmtd::config'
  it_behaves_like 'beegfs::mgmtd::service'
end
