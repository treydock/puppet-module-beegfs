require 'spec_helper'

shared_context 'fhgfs::repo' do
  it { should contain_class('fhgfs::params') }

  let :default_version do
    facts[:fhgfs_version].nil? ? '2012.10' : facts[:fhgfs_version]
  end

  let :version do
    params[:version].nil? ? default_version : params[:version]
  end

  let :os_maj_version do
    facts[:operatingsystemrelease].split(".").first
  end
  
  let :defined_params do
    {
      :version      => default_version,
      :repo_baseurl => "http://www.fhgfs.com/release/fhgfs_#{version}/dists/rhel#{os_maj_version}",
      :repo_gpgkey  => "http://www.fhgfs.com/release/fhgfs_#{version}/gpg/RPM-GPG-KEY-fhgfs",
      :repo_descr   => "FhGFS #{version} (RHEL#{os_maj_version})"
    }.merge(params)
  end

  it do
    should contain_yumrepo('fhgfs').with({
      'descr'     => defined_params[:repo_descr],
      'baseurl'   => defined_params[:repo_baseurl],
      'gpgkey'    => defined_params[:repo_gpgkey],
      'gpgcheck'  => '0',
      'enabled'   => '1',
    })
  end
end
