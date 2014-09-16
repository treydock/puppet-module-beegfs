require 'spec_helper'

describe 'fhgfs::storage' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs::storage') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it { should contain_anchor('fhgfs::storage::start').that_comes_before('Class[fhgfs::storage::install]') }
  it { should contain_class('fhgfs::storage::install').that_comes_before('Class[fhgfs::storage::config]') }
  it { should contain_class('fhgfs::storage::config').that_comes_before('Class[fhgfs::storage::service]') }
  it { should contain_class('fhgfs::storage::service').that_comes_before('Anchor[fhgfs::storage::end]') }
  it { should contain_anchor('fhgfs::storage::end') }

  include_context 'fhgfs::storage::install'
  include_context 'fhgfs::storage::config'
  include_context 'fhgfs::storage::service'

  # Test validate_bool parameters
  [
    :manage_service,
    :service_autorestart,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::storage') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    :conn_interfaces,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::storage') }.to raise_error(Puppet::Error, /is not an Array/) }
    end
  end

  # Test validate_array parameters
  [
    :config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::storage') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
