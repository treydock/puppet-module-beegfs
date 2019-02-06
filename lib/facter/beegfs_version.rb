# beegfs_version.rb

Facter.add(:beegfs_version) do
  confine :osfamily => "RedHat"
  setcode do
    if beegfs_v_match = Facter::Core::Execution.exec("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").match(/^beegfs-common-(.*)$/)
      beegfs_v = beegfs_v_match[1]
      beegfs_v
    end
  end
end
