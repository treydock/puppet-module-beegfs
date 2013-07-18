# fhgfs_version.rb

Facter.add(:fhgfs_version) do
  confine :osfamily => "RedHat"
  setcode do
    if Facter::Util::Resolution.which('rpm')
      fhgfs_v = Facter::Util::Resolution.exec("rpm -q --queryformat '%{VERSION}' fhgfs-common")
      fhgfs_v
    end
  end
end
