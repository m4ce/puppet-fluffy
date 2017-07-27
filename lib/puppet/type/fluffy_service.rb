Puppet::Type.newtype(:fluffy_service) do
  @doc = 'Manage Fluffy services'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Service name'
  end

  newproperty(:dst_port, :array_matching => :all) do
    desc 'Destination port(s)'
    defaultto([])

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
  end

  newproperty(:src_port, :array_matching => :all) do
    desc 'Source port(s)'
    defaultto([])

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
  end

  newproperty(:protocol) do
    desc 'Network protocol'
    defaultto(:all)
    newvalues(:ip,:tcp,:udp,:icmp,'ipv6-icmp',:esp,:ah,:vrrp,:igmp,:ipencap,:ipv4,:ipv6,:ospf,:gre,:cbt,:sctp,:pim,:all)
  end

  validate do
    if self[:ensure] != :absent
      fail("Either source or destination ports are required for #{self[:name]}") if !self[:dst_port].size and !self[:src_port].size
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end
end
