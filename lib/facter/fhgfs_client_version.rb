# fhgfs_client_version.rb

require 'facter/util/fhgfs'

Facter.add(:fhgfs_client_version) do
  confine :osfamily => "RedHat"
  setcode do
    Facter::Util::Fhgfs.get_version('fhgfs-client')
  end
end
