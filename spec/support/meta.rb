shared_examples_for 'fhgfs::meta' do
  it { should create_class('fhgfs::meta') }

  it { should contain_anchor('fhgfs::meta::start').that_comes_before('Class[fhgfs::repo]') }
  it { should contain_class('fhgfs::repo').that_comes_before('Class[fhgfs::meta::install]') }
  it { should contain_class('fhgfs::meta::install').that_comes_before('Class[fhgfs::meta::config]') }
  it { should contain_class('fhgfs::meta::config').that_comes_before('Class[fhgfs::meta::service]') }
  it { should contain_class('fhgfs::meta::service').that_comes_before('Anchor[fhgfs::meta::end]') }
  it { should contain_anchor('fhgfs::meta::end') }

  it_behaves_like 'fhgfs::repo'
  it_behaves_like 'fhgfs::meta::install'
  it_behaves_like 'fhgfs::meta::config'
  it_behaves_like 'fhgfs::meta::service'

end
