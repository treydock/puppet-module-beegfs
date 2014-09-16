require 'spec_helper'

describe 'fhgfs::mgmtd' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs::mgmtd') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it { should contain_anchor('fhgfs::mgmtd::start').that_comes_before('Class[fhgfs::mgmtd::install]') }
  it { should contain_class('fhgfs::mgmtd::install').that_comes_before('Class[fhgfs::mgmtd::config]') }
  it { should contain_class('fhgfs::mgmtd::config').that_comes_before('Class[fhgfs::mgmtd::service]') }
  it { should contain_class('fhgfs::mgmtd::service').that_comes_before('Anchor[fhgfs::mgmtd::end]') }
  it { should contain_anchor('fhgfs::mgmtd::end') }

  include_context 'fhgfs::mgmtd::install'
  include_context 'fhgfs::mgmtd::config'
  include_context 'fhgfs::mgmtd::service'

  # Test validate_bool parameters
  [
    :manage_service,
    :service_autorestart,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::mgmtd') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    :conn_interfaces,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::mgmtd') }.to raise_error(Puppet::Error, /is not an Array/) }
    end
  end

  # Test validate_array parameters
  [
    :config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('fhgfs::mgmtd') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
