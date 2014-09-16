shared_examples_for 'fhgfs::client' do
  it { should create_class('fhgfs::client') }

  it { should contain_anchor('fhgfs::client::start').that_comes_before('Class[fhgfs::repo]') }
  it { should contain_class('fhgfs::repo').that_comes_before('Class[fhgfs::client::install]') }
  it { should contain_class('fhgfs::client::install').that_comes_before('Class[fhgfs::client::config]') }
  it { should contain_class('fhgfs::client::config').that_comes_before('Class[fhgfs::client::service]') }
  it { should contain_class('fhgfs::client::service').that_comes_before('Anchor[fhgfs::client::end]') }
  it { should contain_anchor('fhgfs::client::end') }

  it_behaves_like 'fhgfs::repo'
  it_behaves_like 'fhgfs::client::install'
  it_behaves_like 'fhgfs::client::config'
  it_behaves_like 'fhgfs::client::service'

end
