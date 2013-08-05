require 'spec_helper'

describe 'fhgfs::repo' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::repo') }

  context 'osfamily => RedHat' do
    it { should include_class('fhgfs::repo::el') }
  end
end
