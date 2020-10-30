require 'spec_helper'

describe 'beegfs' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
    end
  end

  let(:facts) do
    on_supported_os['centos-7-x86_64']
  end

  it { is_expected.to create_class('beegfs') }
  it { is_expected.to contain_class('beegfs::params') }
  it { is_expected.to contain_class('beegfs::defaults') }

  it { is_expected.to contain_class('beegfs::client') }

  it { is_expected.not_to contain_class('beegfs::mgmtd') }
  it { is_expected.not_to contain_class('beegfs::meta') }
  it { is_expected.not_to contain_class('beegfs::storage') }
  it { is_expected.not_to contain_class('beegfs::admon') }

  it_behaves_like 'beegfs::client'

  context 'when mgmtd => true and meta => true' do
    let(:params) { { mgmtd: true, meta: true } }

    it { is_expected.to compile.with_all_deps }
  end

  context 'when storage => true and meta => true' do
    let(:params) { { storage: true, meta: true } }

    it { is_expected.to compile.with_all_deps }
  end

  context 'when mgmtd => true' do
    let(:params) { { mgmtd: true } }

    it { is_expected.to contain_class('beegfs::mgmtd') }

    it { is_expected.not_to contain_class('beegfs::meta') }
    it { is_expected.not_to contain_class('beegfs::storage') }
    it { is_expected.not_to contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::mgmtd'
  end

  context 'when meta => true' do
    let(:params) { { meta: true } }

    it { is_expected.to contain_class('beegfs::meta') }

    it { is_expected.not_to contain_class('beegfs::mgmtd') }
    it { is_expected.not_to contain_class('beegfs::storage') }
    it { is_expected.not_to contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::meta'
  end

  context 'when storage => true' do
    let(:params) { { storage: true } }

    it { is_expected.to contain_class('beegfs::storage') }

    it { is_expected.not_to contain_class('beegfs::mgmtd') }
    it { is_expected.not_to contain_class('beegfs::meta') }
    it { is_expected.not_to contain_class('beegfs::admon') }

    it_behaves_like 'beegfs::storage'
  end

  context 'when admon => true' do
    let(:params) { { admon: true } }

    it { is_expected.to contain_class('beegfs::admon') }

    it { is_expected.not_to contain_class('beegfs::mgmtd') }
    it { is_expected.not_to contain_class('beegfs::meta') }
    it { is_expected.not_to contain_class('beegfs::storage') }

    it_behaves_like 'beegfs::admon'
  end

  context 'osfamily => Foo' do
    let(:facts) { { osfamily: 'Foo' } }

    it 'raises an error' do
      is_expected.to compile.and_raise_error(%r{Unsupported osfamily})
    end
  end
end
