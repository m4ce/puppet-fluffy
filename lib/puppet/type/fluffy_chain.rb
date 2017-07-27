Puppet::Type.newtype(:fluffy_chain) do
  @doc = 'Manage Fluffy chains'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:chain, :namevar => true) do
    desc 'Fluffy chain'
  end

  newparam(:table, :namevar => true) do
    desc 'Fluffy routing table'

    defaultto(:filter)
    newvalues(:filter, :nat, :mangle, :raw, :security)
  end

  newproperty(:policy) do
    desc 'Default policy'
    defaultto('ACCEPT')
    newvalues('ACCEPT', 'DROP', 'RETURN')
  end

  def self.title_patterns
    [
      [ /(^([^:]*)$)/,
        [ [:chain] ] ],
      [ /^([^:]+):([^:]+)$/,
        [ [:table], [:chain] ]
      ]
    ]
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
