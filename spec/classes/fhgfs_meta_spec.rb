require 'spec_helper'

describe 'fhgfs::meta' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs::meta') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it { should contain_anchor('fhgfs::meta::start').that_comes_before('Class[fhgfs::meta::install]') }
  it { should contain_class('fhgfs::meta::install').that_comes_before('Class[fhgfs::meta::config]') }
  it { should contain_class('fhgfs::meta::config').that_comes_before('Class[fhgfs::meta::service]') }
  it { should contain_class('fhgfs::meta::service').that_comes_before('Anchor[fhgfs::meta::end]') }
  it { should contain_anchor('fhgfs::meta::end') }

  include_context 'fhgfs::meta::install'
  include_context 'fhgfs::meta::config'
  include_context 'fhgfs::meta::service'

  # Test validate_bool parameters
  [
    :manage_service,
    :service_autorestart,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::meta') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    :conn_interfaces,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::meta') }.to raise_error(Puppet::Error, /is not an Array/) }
    end
  end

  # Test validate_array parameters
  [
    :config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::meta') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
