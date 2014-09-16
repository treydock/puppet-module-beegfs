require 'spec_helper'

describe 'fhgfs::admon' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs::admon') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it { should contain_anchor('fhgfs::admon::start').that_comes_before('Class[fhgfs::admon::install]') }
  it { should contain_class('fhgfs::admon::install').that_comes_before('Class[fhgfs::admon::config]') }
  it { should contain_class('fhgfs::admon::config').that_comes_before('Class[fhgfs::admon::service]') }
  it { should contain_class('fhgfs::admon::service').that_comes_before('Anchor[fhgfs::admon::end]') }
  it { should contain_anchor('fhgfs::admon::end') }

  include_context 'fhgfs::admon::install'
  include_context 'fhgfs::admon::config'
  include_context 'fhgfs::admon::service'

  # Test validate_bool parameters
  [
    :manage_service,
    :service_autorestart,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::admon') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    :config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::admon') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
