Puppet::Type.newtype(:fluffy_rollback_check) do
  @doc = 'Manage Fluffy rollback checks'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Rollback check name'
  end

  newproperty(:type) do
    desc 'Check type'

    newvalues(:tcp, :exec)
  end

  newproperty(:host) do
    desc 'TCP host'

    defaultto('0.0.0.0')
  end

  newproperty(:port) do
    desc 'TCP port'

    validate do |value|
      if value != :absent
        fail("Port must be a valid Integer in #{self[:name]}") unless value.is_a?(Integer)
      end
    end

    defaultto(:absent)
  end

  newproperty(:timeout) do
    desc 'Check timeout'

    validate do |value|
      fail("Timeout must be a positive Integer in #{self[:name]}") unless value.is_a?(Integer)
    end

    defaultto(5)
  end

  newproperty(:command) do
    desc 'Command to run for exec type of checks'

    defaultto(:absent)
  end

  validate do
    if self[:ensure] != :absent
      fail("Check type is required in #{self[:name]}") if self[:type].nil?
      fail("Command is required for exec check types in #{self[:name]}") if self[:type] == :exec and self[:command] == :absent
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
