shared_context :defaults do
  let :default_facts do
    {
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
      :os_maj_version           => '6',
    }
  end
end
