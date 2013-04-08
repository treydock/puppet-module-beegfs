# fhgfs.rb

module Facter::Util::Fhgfs
  class << self
  def get_version(package)
    version_found = Facter::Util::Resolution.exec("/bin/rpm -q --queryformat '%{VERSION}' #{package}")
    version_found
  end
  end
end
