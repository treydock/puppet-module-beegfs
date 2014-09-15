require 'spec_helper'

describe 'fhgfs' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.5',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs::repo') }

  context 'osfamily => Foo' do
    let(:facts) {{ :osfamily => "Foo" }}
  
    it { expect { should create_class('fhgfs') }.to raise_error(Puppet::Error, /Unsupported osfamily/) }
  end
end
