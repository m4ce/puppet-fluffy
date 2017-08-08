Puppet::Type.newtype(:fluffy_rule) do
  @doc = 'Manage Fluffy rules'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Friendly name'
  end

  newparam(:rule, :namevar => true) do
    desc 'Rule name'
    newvalues(/^[\w_]+/)
  end

  newparam(:chain, :namevar => true) do
    desc 'Rule chain name'
  end

  newparam(:table, :namevar => true) do
    desc 'Rule packet filtering table'

    defaultto(:filter)
    newvalues(:filter,:nat,:mangle,:raw,:security)
  end

  newproperty(:index) do
    desc 'Rule index'
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

    defaultto(:false)
    newvalues(:true,:false)
  end

  newproperty(:protocol) do
    desc 'Network protocol'

    defaultto(:absent)
    newvalues(:absent,:ip,:tcp,:udp,:icmp,'ipv6-icmp',:esp,:ah,:vrrp,:igmp,:ipencap,:ipv4,:ipv6,:ospf,:gre,:cbt,:sctp,:pim,:all)
  end

  newproperty(:negate_icmp_type, :boolean => true) do
    desc 'Negate ICMP type'

    defaultto(:false)
    newvalues(:true,:false)
  end

  newproperty(:icmp_type) do
    desc 'ICMP type'

    defaultto(:absent)
    newvalues(:absent, :any, 'echo-reply','destination-unreachable','network-unreachable','host-unreachable','protocol-unreachable','port-unreachable','fragmentation-needed','source-route-failed','network-unknown','host-unknown','network-prohibited','host-prohibited','TOS-network-unreachable','TOS-host-unreachable','communication-prohibited','host-precedence-violation','precedence-cutoff','source-quench','redirect','network-redirect','host-redirect','TOS-network-redirect','TOS-host-redirect','echo-request','router-advertisement','router-solicitation','time-exceeded','ttl-zero-during-transit','ttl-zero-during-reassembly','parameter-problem','ip-header-bad','required-option-missing','timestamp-request','timestamp-reply','address-mask-request','address-mask-reply')
  end

  newproperty(:negate_tcp_flags, :boolean => true) do
    desc 'Negate TCP flags'

    defaultto(:false)
    newvalues(:true,:false)
  end

  newproperty(:tcp_flags) do
    desc 'TCP flags'

    defaultto(:absent)
  end

  newproperty(:negate_ctstate, :boolean => true) do
    desc 'Negate conntrack state'

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
  end

  newproperty(:in_interface, :array_matching => :all) do
    desc 'Input interface'

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

  newproperty(:negate_out_interface, :boolean => true) do
    desc 'Negate output interface'

    defaultto(:false)
    newvalues(:true,:false)
  end

  newproperty(:out_interface, :array_matching => :all) do
    desc 'Output interface'

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

  newproperty(:negate_src_address, :boolean => true) do
    desc 'Negate source address(es)'

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
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

    defaultto(:false)
    newvalues(:true,:false)
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
    newvalues(:absent,'icmp-net-unreachable','icmp-host-unreachable','icmp-port-unreachable','icmp-proto-unreachable','icmp-net-prohibited','icmp-host-prohibited','icmp-admin-prohibited')
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

    defaultto(:false)
    newvalues(:true,:false)
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
    newvalues(:absent,:emerg,:alert,:crit,:err,:warning,:notice,:info,:debug)
  end

  newproperty(:comment) do
    desc 'Comment'

    defaultto(:absent)
  end

  def self.title_patterns
    [
      [ /(^([^:]*)$)/,
        [ [:name], [:rule] ]
      ],
      [ /(^([^:]+):([^:]+):([^:]+)$)/,
        [ [:name], [:table], [:chain], [:rule] ]
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

    [:src_service, :dst_service].each do |k|
      self[k].each do |service|
        req << service unless builtin_services.include?(service)
      end
    end

    req
  end

  autorequire(:fluffy_interface) do
    builtin_interfaces = ['any']
    req = []

    [:in_interface, :out_interface].each do |k|
      self[k].each do |interface|
        req << interface unless builtin_interfaces.include?(interface)
      end
    end

    req
  end

  autorequire(:fluffy_address) do
    reserved_addresses = ['any', 'any_broadcast']
    req = []

    [:src_address, :dst_address, :src_address_range, :dst_address_range].each do |k|
      self[k].each do |address|
        req << address unless reserved_addresses.include?(address)
      end
    end

    req
  end

  validate do
    if self[:ensure] != :absent
      fail "Either jump or action are required for #{self[:name]}" unless self[:action] or self[:jump]
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
