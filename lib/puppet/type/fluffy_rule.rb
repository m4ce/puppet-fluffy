Puppet::Type.newtype(:fluffy_rule) do
  @doc = 'Manage Fluffy rules'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Rule name'
    newvalues(/^[\w_]+/)
  end

  newparam(:chain, :namevar => true) do
    desc 'Rule chain name'
  end

  newparam(:table, :namevar => true) do
    desc 'Rule packet filtering table'

    defaultto(:filter)
    newvalues(:filter, :nat, :mangle, :raw, :security)
  end

  newparam(:before_rule) do
    desc 'Add the new rule before the specified rule name'
  end

  newparam(:after_rule) do
    desc 'Add the new rule after the specified rule name'
  end

  newproperty(:action) do
    desc 'Rule action'

    defaultto(:absent)
    newvalues(:absent,'ACCEPT','DROP','REJECT','QUEUE','RETURN','DNAT','SNAT','LOG','MASQUERADE','REDIRECT','MARK','TCPMSS')
  end

  newproperty(:jump) do
    desc 'Rule jump target'

    defaultto(:absent)
  end

  newproperty(:negate_protocol, :boolean => true) do
    desc 'Negate protocol'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:protocol) do
    desc 'Network protocol'

    defaultto(:absent)
    newvalues(:absent,:ip,:tcp,:udp,:icmp,'ipv6-icmp',:esp,:ah,:vrrp,:igmp,:ipencap,:ipv4,:ipv6,:ospf,:gre,:cbt,:sctp,:pim,:all)
  end

  newproperty(:negate_icmp_type, :boolean => true) do
    desc 'Negate ICMP type'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:icmp_type) do
    desc 'ICMP type'

    defaultto(:absent)
    newvalues(:absent,:any,'echo-reply','echo-request')
  end

  newproperty(:negate_tcp_flags, :boolean => true) do
    desc 'Negate TCP flags'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:tcp_flags) do
    desc 'TCP flags'

    defaultto(:absent)
  end

  newproperty(:negate_ctstate, :boolean => true) do
    desc 'Negate conntrack state'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:ctstate, :array_matching => :all) do
    desc 'Conntrack state(s)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_state, :boolean => true) do
    desc 'Negate connection state(s)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:state, :array_matching => :all) do
    desc 'Connection state(s)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_src_address_range, :boolean => true) do
    desc 'Negate source range address(es)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:src_address_range, :array_matching => :all) do
    desc 'Source range address(es)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_dst_address_range, :boolean => true) do
    desc 'Negate destination range address(es)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:dst_address_range, :array_matching => :all) do
    desc 'Destination range address(es)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_in_interface, :boolean => true) do
    desc 'Negate input interface'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:in_interface) do
    desc 'Input interface'

    defaultto(:absent)
  end

  newproperty(:negate_out_interface, :boolean => true) do
    desc 'Negate output interface'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:out_interface) do
    desc 'Output interface'

    defaultto(:absent)
  end

  newproperty(:negate_src_address, :boolean => true) do
    desc 'Negate source address(es)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:src_address, :array_matching => :all) do
    desc 'Source address(es)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_dst_address, :boolean => true) do
    desc 'Negate destination address(es)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:dst_address, :array_matching => :all) do
    desc 'Destination address(es)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_src_service, :boolean => true) do
    desc 'Negate source service(s)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:src_service, :array_matching => :all) do
    desc 'Source services(s)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:negate_dst_service, :boolean => true) do
    desc 'Negate destination service(s)'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:dst_service, :array_matching => :all) do
    desc 'Destination services(s)'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end

    def should_to_s(newvalue = @should)
      if newvalue
        newvalue.inspect
      else
        nil
      end
    end

    defaultto([])
  end

  newproperty(:reject_with) do
    desc 'Reject with'

    defaultto(:absent)
    newvalues(:absent, 'icmp-net-unreachable', 'icmp-host-unreachable', 'icmp-port-unreachable', 'icmp-proto-unreachable', 'icmp-net-prohibited', 'icmp-host-prohibited', 'icmp-admin-prohibited')
  end

  newproperty(:set_mss) do
    desc 'Set maximum segment size (MSS)'

    validate do |value|
      if value != :absent
        fail "Rule MSS '#{value}' is not an Integer for #{self[:name]}" unless value.is_a?(Integer)
      end
    end

    defaultto(:absent)
  end

  newproperty(:clamp_mss_to_pmtu, :boolean => true) do
    desc 'Clamp MSS to path MTU'

    defaultto(false)
    newvalues(true,false)
  end

  newproperty(:to_src) do
    desc 'Source NAT'

    defaultto(:absent)
  end

  newproperty(:to_dst) do
    desc 'Destination NAT'

    defaultto(:absent)
  end

  newproperty(:limit) do
    desc 'Limit rate'

    defaultto(:absent)
  end

  newproperty(:limit_burst) do
    desc 'Limit burst'

    defaultto(:absent)
  end

  newproperty(:log_prefix) do
    desc 'Log prefix'

    defaultto(:absent)
  end

  newproperty(:log_level) do
    desc 'Log level'

    defaultto(:absent)
    newvalues(:absent, :emerg, :alert, :crit, :err, :warning, :notice, :info, :debug)
  end

  newproperty(:comment) do
    desc 'Comment'

    defaultto(:absent)
  end

  def self.title_patterns
    [
      [ /(^([^:]*)$)/,
        [ [:name] ] ],
      [ /^([^:]+):([^:]+):([^:]+)$$/,
        [ [:table], [:chain], [:name] ]
      ]
    ]
  end

  autorequire(:fluffy_chain) do
    builtin_chains = {
      :filter => ['INPUT', 'FORWARD', 'OUTPUT'],
      :nat => ['INPUT', 'OUTPUT', 'PREROUTING', 'POSTROUTING'],
      :mangle => ['INPUT', 'FORWARD', 'OUTPUT', 'PREROUTING', 'POSTROUTING'],
      :raw => ['PREROUTING', 'OUTPUT'],
      :security => ['INPUT', 'FORWARD', 'OUTPUT']
    }

    unless builtin_chains[self[:table]].include?(self[:chain])
      ["#{self[:table]}:#{self[:chain]}"]
    else
      []
    end
  end

  autorequire(:fluffy_service) do
    builtin_services = ['any']
    req = []

    self[:src_service].each do |service|
      req << service unless builtin_services.include?(service)
    end
    self[:dst_service].each do |service|
      req << service unless builtin_services.include?(service)
    end

    req
  end

  autorequire(:fluffy_interface) do
    builtin_interfaces = ['any']
    req = []

    req << self[:in_interface] if self[:in_interface] and !builtin_interfaces.include?(self[:in_interface])
    req << self[:out_interface] if self[:out_interface] and !builtin_interfaces.include?(self[:out_interface])
    req
  end


  autorequire(:fluffy_rule) do
    if self[:before_rule]
      [self[:before_rule]]
    elsif self[:after_rule]
      [self[:after_rule]]
    else
      []
    end
  end

  validate do
    if self[:ensure] != :absent
      fail "Before and after rule cannot be used at the same time for #{self[:name]}" if self[:before_rule] and self[:after_rule]
      fail "Either jump or action are required for #{self[:name]}" unless self[:action] or self[:jump]
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
