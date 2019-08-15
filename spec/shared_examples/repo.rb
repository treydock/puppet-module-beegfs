shared_examples_for 'beegfs::repo' do
  it { is_expected.to create_class('beegfs::repo') }

  it do
    is_expected.to contain_yumrepo('beegfs').with('descr' => 'BeeGFS 7.1.x (RHEL7)',
                                                  'baseurl'   => 'https://www.beegfs.io/release/beegfs_7_1/dists/rhel7',
                                                  'gpgkey'    => 'https://www.beegfs.io/release/beegfs_7_1/gpg/RPM-GPG-KEY-beegfs',
                                                  'gpgcheck'  => '0',
                                                  'enabled'   => '1')
  end

  context 'with customer login' do
    let(:params) { { customer_login: 'test:secret' } }

    it { is_expected.to contain_yumrepo('beegfs').with_baseurl('https://test:secret@www.beegfs.io/login/release/beegfs_7_1/dists/rhel7') }
  end

  context 'with custom baseurl' do
    let(:params) { { repo_baseurl: 'http://yum.example.com/beegfs/beegfs_2015.03/dists/rhel6' } }

    it { is_expected.to contain_yumrepo('beegfs').with_baseurl('http://yum.example.com/beegfs/beegfs_2015.03/dists/rhel6') }
  end

  context 'with custom gpgkey' do
    let(:params) { { repo_gpgkey: 'http://foo.com/RPM-GPG-KEY-beegfs' } }

    it { is_expected.to contain_yumrepo('beegfs').with_gpgkey('http://foo.com/RPM-GPG-KEY-beegfs') }
  end

  context "with gpgcheck => '1'" do
    let(:params) { { repo_gpgcheck: '1' } }

    it { is_expected.to contain_yumrepo('beegfs').with_gpgcheck('1') }
  end

  context "with enabled => '0'" do
    let(:params) { { repo_enabled: '0' } }

    it { is_expected.to contain_yumrepo('beegfs').with_enabled('0') }
  end
end
