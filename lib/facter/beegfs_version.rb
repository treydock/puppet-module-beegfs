# beegfs_version.rb

Facter.add(:beegfs_version) do
  confine osfamily: 'RedHat'
  setcode do
    beegfs_v_match = Facter::Core::Execution.exec("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").match(%r{^beegfs-common-(.*)$})
    if beegfs_v_match
      beegfs_v = beegfs_v_match[1]
      beegfs_v
    end
  end
end
