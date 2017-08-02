Puppet::Type.newtype(:fluffy_chain) do
  @doc = 'Manage Fluffy chains'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Composite namevar'
  end

  newparam(:chain, :namevar => true) do
    desc 'Fluffy chain'
  end

  newparam(:table, :namevar => true) do
    desc 'Fluffy routing table'

    defaultto(:filter)
    newvalues(:filter,:nat,:mangle,:raw,:security)
  end

  newproperty(:policy) do
    desc 'Default policy'

    defaultto('ACCEPT')
    newvalues('ACCEPT','DROP','RETURN')
  end

  def self.title_patterns
    [
      [ /(^([^:]+)$)/,
        [ [:name], [:chain] ]
      ],
      [ /(^([^:]+):([^:]+)$)/,
        [ [:name], [:table], [:chain] ]
      ]
    ]
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
