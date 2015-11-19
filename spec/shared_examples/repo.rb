shared_examples_for 'beegfs::repo' do
  it { should create_class('beegfs::repo') }

  it do
    should contain_yumrepo('beegfs').with({
      'descr'     => "BeeGFS 2015.03 (RHEL6)",
      'baseurl'   => "http://www.beegfs.com/release/beegfs_2015.03/dists/rhel6",
      'gpgkey'    => 'http://www.beegfs.com/release/beegfs_2015.03/gpg/RPM-GPG-KEY-beegfs',
      'gpgcheck'  => '0',
      'enabled'   => '1',
    })
  end

  context "with custom baseurl" do
    let(:params) {{ :repo_baseurl => 'http://yum.example.com/beegfs/beegfs_2015.03/dists/rhel6' }}
    it { should contain_yumrepo('beegfs').with_baseurl("http://yum.example.com/beegfs/beegfs_2015.03/dists/rhel6") }
  end

  context "with custom gpgkey" do
    let(:params) {{ :repo_gpgkey => 'http://foo.com/RPM-GPG-KEY-beegfs' }}
    it { should contain_yumrepo('beegfs').with_gpgkey("http://foo.com/RPM-GPG-KEY-beegfs") }
  end

  context "with gpgcheck => '1'" do
    let(:params) {{ :repo_gpgcheck => '1' }}
    it { should contain_yumrepo('beegfs').with_gpgcheck('1') }
  end

  context "with enabled => '0'" do
    let(:params) {{ :repo_enabled => '0' }}
    it { should contain_yumrepo('beegfs').with_enabled('0') }
  end
end
