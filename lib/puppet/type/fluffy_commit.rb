Puppet::Type.newtype(:fluffy_commit) do
  @doc = 'Manage Fluffy commit process for the current session'

  newparam(:name, :namevar => true) do
    desc 'Session name'

    newvalues(:puppet)
  end

  newparam(:rollback, :boolean => true) do
    desc 'Enable rollback'

    defaultto(:false)
    newvalues(:true, :false)
  end

  newparam(:rollback_interval) do
    desc 'Rollback interval in seconds. Defaults to 0.'

    defaultto(0)

    validate do |value|
      unless value == :absent
        fail "Rollback interval '#{value}' is not an Integer" unless value.is_a?(Integer)
      end
    end
  end

  def refresh
    provider.commit
  end
end
