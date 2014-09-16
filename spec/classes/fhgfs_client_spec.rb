require 'spec_helper'

describe 'fhgfs::client' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs::client') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it { should contain_anchor('fhgfs::client::start').that_comes_before('Class[fhgfs::client::install]') }
  it { should contain_class('fhgfs::client::install').that_comes_before('Class[fhgfs::client::config]') }
  it { should contain_class('fhgfs::client::config').that_comes_before('Class[fhgfs::client::service]') }
  it { should contain_class('fhgfs::client::service').that_comes_before('Anchor[fhgfs::client::end]') }
  it { should contain_anchor('fhgfs::client::end') }

  include_context 'fhgfs::client::install'
  include_context 'fhgfs::client::config'
  include_context 'fhgfs::client::service'

  # Test validate_bool parameters
  [
    :build_enabled,
    :manage_service,
    :service_autorestart,
    :utils_only,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::client') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    :conn_interfaces,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::client') }.to raise_error(Puppet::Error, /is not an Array/) }
    end
  end

  # Test validate_array parameters
  [
    :config_overrides,
    :helperd_config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::client') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
