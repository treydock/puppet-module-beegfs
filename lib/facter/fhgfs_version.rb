# fhgfs_version.rb

Facter.add(:fhgfs_version) do
  confine :osfamily => "RedHat"

  if fhgfs_v_match = Facter::Util::Resolution.exec("rpm -q --queryformat '%{NAME}-%{VERSION}' fhgfs-common").match(/^fhgfs-common-(.*)$/)
    setcode do
      fhgfs_v = fhgfs_v_match[1]
      fhgfs_v
    end
  end
end
