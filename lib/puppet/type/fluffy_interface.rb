Puppet::Type.newtype(:fluffy_interface) do
  @doc = 'Manage Fluffy interfaces'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Friendly name for the interface'
  end

  newproperty(:interface) do
    desc 'Network interface'
  end

  validate do
    if self[:ensure] != :absent
      raise ArgumentError, "Fluffy interface required for #{self[:name]}" unless self[:interface]
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
