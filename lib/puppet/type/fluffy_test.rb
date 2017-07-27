Puppet::Type.newtype(:fluffy_test) do
  @doc = 'Manage Fluffy test process for the current session'

  newparam(:name, :namevar => true) do
    desc 'Session name'

    newvalues(:puppet)
  end

  def refresh
    provider.test
  end
end
