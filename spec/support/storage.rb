shared_examples_for 'fhgfs::storage' do
  it { should create_class('fhgfs::storage') }

  it { should contain_anchor('fhgfs::storage::start').that_comes_before('Class[fhgfs::repo]') }
  it { should contain_class('fhgfs::repo').that_comes_before('Class[fhgfs::storage::install]') }
  it { should contain_class('fhgfs::storage::install').that_comes_before('Class[fhgfs::storage::config]') }
  it { should contain_class('fhgfs::storage::config').that_comes_before('Class[fhgfs::storage::service]') }
  it { should contain_class('fhgfs::storage::service').that_comes_before('Anchor[fhgfs::storage::end]') }
  it { should contain_anchor('fhgfs::storage::end') }

  it_behaves_like 'fhgfs::repo'
  it_behaves_like 'fhgfs::storage::install'
  it_behaves_like 'fhgfs::storage::config'
  it_behaves_like 'fhgfs::storage::service'

end
