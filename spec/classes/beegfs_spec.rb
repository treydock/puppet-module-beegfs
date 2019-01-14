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
    on_supported_os['centos-7-x86_64']
  end
  it { should create_class('beegfs') }
  it { should contain_class('beegfs::params') }
  it { should contain_class('beegfs::defaults') }

  it { should contain_class('beegfs::client') }

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

    it { should contain_class('beegfs::mgmtd') }

    it { should_not contain_class('beegfs::meta') }
    it { should_not contain_class('beegfs::storage') }
    it { should_not contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::mgmtd'
  end

  context 'when meta => true' do
    let(:params) {{ :meta => true }}

    it { should contain_class('beegfs::meta') }

    it { should_not contain_class('beegfs::mgmtd') }
    it { should_not contain_class('beegfs::storage') }
    it { should_not contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::meta'
  end

  context 'when storage => true' do
    let(:params) {{ :storage => true }}

    it { should contain_class('beegfs::storage') }

    it { should_not contain_class('beegfs::mgmtd') }
    it { should_not contain_class('beegfs::meta') }
    it { should_not contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::storage'
  end

  context 'when admon => true' do
    let(:params) {{ :admon => true }}

    it { should contain_class('beegfs::admon') }

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
end
