require 'spec_helper'

describe 'beegfs' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile.with_all_deps }
    end
  end

  let(:facts) do
    on_supported_os['centos-6-x86_64']
  end
  it { should create_class('beegfs') }
  it { should contain_class('beegfs::params') }
  it { should contain_class('beegfs::defaults') }

  it { should contain_anchor('beegfs::start').that_comes_before('Class[beegfs::client]') }
  it { should contain_class('beegfs::client').that_comes_before('Anchor[beegfs::end]') }
  it { should contain_anchor('beegfs::end') }

  it { should_not contain_class('beegfs::mgmtd') }
  it { should_not contain_class('beegfs::meta') }
  it { should_not contain_class('beegfs::storage') }
  it { should_not contain_class('beegfs::admon') }

  it_behaves_like 'beegfs::client'

  context 'when mgmtd => true and meta => true' do
    let(:params) {{ :mgmtd => true, :meta => true }}

    it { should compile.with_all_deps }
  end

  context 'when storage => true and meta => true' do
    let(:params) {{ :storage => true, :meta => true }}

    it { should compile.with_all_deps }
  end

  context 'when mgmtd => true' do
    let(:params) {{ :mgmtd => true }}

    it { should contain_anchor('beegfs::start').that_comes_before('Class[beegfs::mgmtd]') }
    it { should contain_class('beegfs::mgmtd').that_comes_before('Anchor[beegfs::end]') }
    it { should contain_anchor('beegfs::end') }

    it { should_not contain_class('beegfs::meta') }
    it { should_not contain_class('beegfs::storage') }
    it { should_not contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::mgmtd'
  end

  context 'when meta => true' do
    let(:params) {{ :meta => true }}

    it { should contain_anchor('beegfs::start').that_comes_before('Class[beegfs::meta]') }
    it { should contain_class('beegfs::meta').that_comes_before('Anchor[beegfs::end]') }
    it { should contain_anchor('beegfs::end') }

    it { should_not contain_class('beegfs::mgmtd') }
    it { should_not contain_class('beegfs::storage') }
    it { should_not contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::meta'
  end

  context 'when storage => true' do
    let(:params) {{ :storage => true }}

    it { should contain_anchor('beegfs::start').that_comes_before('Class[beegfs::storage]') }
    it { should contain_class('beegfs::storage').that_comes_before('Anchor[beegfs::end]') }
    it { should contain_anchor('beegfs::end') }

    it { should_not contain_class('beegfs::mgmtd') }
    it { should_not contain_class('beegfs::meta') }
    it { should_not contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::storage'
  end

  context 'when admon => true' do
    let(:params) {{ :admon => true }}

    it { should contain_anchor('beegfs::start').that_comes_before('Class[beegfs::admon]') }
    it { should contain_class('beegfs::admon').that_comes_before('Anchor[beegfs::end]') }
    it { should contain_anchor('beegfs::end') }

    it { should_not contain_class('beegfs::mgmtd') }
    it { should_not contain_class('beegfs::meta') }
    it { should_not contain_class('beegfs::storage') }

    it_behaves_like 'beegfs::admon'
  end

  context 'osfamily => Foo' do
    let(:facts) {{ :osfamily => "Foo" }}
    it 'should raise an error' do
      expect { should compile }.to raise_error(/Unsupported osfamily/)
    end
  end

  # Test validate_bool parameters
  [
    :client,
    :mgmtd,
    :meta,
    :storage,
    :admon,
    :utils_only,
    :manage_client_dependencies,
    :client_build_enabled,
    :client_manage_service,
    :client_service_autorestart,
    :mgmtd_manage_service,
    :mgmtd_service_autorestart,
    :meta_manage_service,
    :meta_service_autorestart,
    :storage_manage_service,
    :storage_service_autorestart,
    :admon_manage_service,
    :admon_service_autorestart,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it 'should raise an error' do
        expect { should compile }.to raise_error(/is not a boolean/)
      end
    end
  end

  # Test validate_array parameters
  [
    :client_conn_interfaces,
    :mgmtd_conn_interfaces,
    :meta_conn_interfaces,
    :storage_conn_interfaces,
    :client_conn_net_filters,
    :mgmtd_conn_net_filters,
    :meta_conn_net_filters,
    :storage_conn_net_filters,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it 'should raise an error' do
        expect { should compile }.to raise_error(/is not an Array/)
      end
    end
  end

  # Test validate_array parameters
  [
    :client_config_overrides,
    :helperd_config_overrides,
    :mgmtd_config_overrides,
    :meta_config_overrides,
    :storage_config_overrides,
    :admon_config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it 'should raise an error' do
        expect { should compile }.to raise_error(/is not a Hash/)
      end
    end
  end
end
