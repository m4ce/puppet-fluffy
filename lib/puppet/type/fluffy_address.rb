Puppet::Type.newtype(:fluffy_address) do
  @doc = 'Manage Fluffy addressbook'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Address name'
  end

  newproperty(:address) do
    desc 'A valid CIDR or IP range'
  end

  validate do
    if self[:ensure] != :absent
      raise ArgumentError, "Fluffy address required for #{self[:name]}" unless self[:address]
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
