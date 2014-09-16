shared_examples_for 'fhgfs::admon' do
  it { should create_class('fhgfs::admon') }

  it { should contain_anchor('fhgfs::admon::start').that_comes_before('Class[fhgfs::repo]') }
  it { should contain_class('fhgfs::repo').that_comes_before('Class[fhgfs::admon::install]') }
  it { should contain_class('fhgfs::admon::install').that_comes_before('Class[fhgfs::admon::config]') }
  it { should contain_class('fhgfs::admon::config').that_comes_before('Class[fhgfs::admon::service]') }
  it { should contain_class('fhgfs::admon::service').that_comes_before('Anchor[fhgfs::admon::end]') }
  it { should contain_anchor('fhgfs::admon::end') }

  it_behaves_like 'fhgfs::repo'
  it_behaves_like 'fhgfs::admon::install'
  it_behaves_like 'fhgfs::admon::config'
  it_behaves_like 'fhgfs::admon::service'

end
