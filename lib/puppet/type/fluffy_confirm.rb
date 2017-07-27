Puppet::Type.newtype(:fluffy_confirm) do
  @doc = 'Manage Fluffy confirm process for the current session'

  newparam(:name, :namevar => true) do
    desc 'Session name'

    newvalues(:puppet)
  end

  def refresh
    provider.confirm
  end
end
