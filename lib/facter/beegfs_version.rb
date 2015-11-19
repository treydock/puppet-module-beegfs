# beegfs_version.rb

Facter.add(:beegfs_version) do
  confine :osfamily => "RedHat"

  if beegfs_v_match = Facter::Util::Resolution.exec("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").match(/^beegfs-common-(.*)$/)
    setcode do
      beegfs_v = beegfs_v_match[1]
      beegfs_v
    end
  end
end
