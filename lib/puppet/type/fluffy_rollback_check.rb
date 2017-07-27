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
    desc 'Host for TCP check'

    defaultto('0.0.0.0')
  end

  newproperty(:port) do
    desc 'Port for TCP check'

    validate do |value|
      if self[:ensure] != :absent
        fail("Port must be a valid Integer in #{self[:name]}") unless value.is_a?(Integer)
      end
    end
  end

  newproperty(:timeout) do
    desc 'Check timeout'

    validate do |value|
      if self[:ensure] != :absent
        fail("Timeout must be a positive Integer in #{self[:name]}") unless value.is_a?(Integer) or value > 0
      end
    end
  end

  newproperty(:command) do
    desc 'Command to run for exec type of checks'
  end

  validate do
    if self[:ensure] != :absent
      fail("Command is required when check type is 'exec' in #{self[:name]}") if self[:type] == :exec and self[:command].nil?
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
