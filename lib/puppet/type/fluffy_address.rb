Puppet::Type.newtype(:fluffy_address) do
  @doc = 'Manage Fluffy addressbook'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc 'Address name'
  end

  newproperty(:address, :array_matching => :all) do
    desc 'A valid CIDR or IP range'

    def insync?(is)
      is.each do |value|
        return false unless @should.include?(value)
      end

      @should.each do |value|
        return false unless is.include?(value)
      end

      true
    end
  end

  autonotify(:fluffy_commit) do
    ['puppet']
  end

  autorequire(:fluffy_address) do
    reserved_addresses = ['any', 'any_broadcast']

    req = []
    if self[:address]
      self[:address].each do |address|
        # is the address a valid CIDR ..?
        next if address =~ /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))?$/
        # is the address a valid IPRange ..?
        next if address =~ /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])-(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
        # are we dealing with a reserved address ..?
        next if reserved_addresses.include?(address)

        # autorequire the address
        req << address
      end
    end
    req
  end
end
