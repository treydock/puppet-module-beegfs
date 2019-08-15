shared_examples_for 'beegfs::install' do
  it { is_expected.not_to contain_package('libbeegfs-ib') }

  context 'when with_rdma => true' do
    let(:params) { { with_rdma: true } }

    it do
      is_expected.to contain_package('libbeegfs-ib').with(ensure: 'present',
                                                          name: 'libbeegfs-ib')
    end

    context "when version => '7.1.3'" do
      let(:params) { { with_rdma: true, version: '7.1.3' } }

      it { is_expected.to contain_package('libbeegfs-ib').with_ensure('7.1.3') }
    end
  end
end
