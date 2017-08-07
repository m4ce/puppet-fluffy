Puppet::Type.newtype(:fluffy_purge) do
  @doc = 'Purge unmanaged Fluffy resources'

  newparam(:name, :namevar => true) do
    newvalues(:rules,:chains,:services,:addressbook,:interfaces)
  end

  newparam(:purge, :boolean => true) do
    desc 'Enable purging'

    defaultto(:false)
    newvalues(:true,:false)
  end

  def able_to_ensure_absent?(resource)
    resource[:ensure] = :absent
  rescue ArgumentError, Puppet::Error
    err _("The 'ensure' attribute on %{name} resources does not accept 'absent' as a value") % { name: resource[:name] }
    false
  end

  def generate
    type = nil
    reserved = []

    case self[:name]
      when :rules
        type = 'fluffy_rule'

      when :chains
        reserved = [
          'filter:FORWARD',
          'filter:INPUT',
          'filter:OUTPUT',
          'mangle:FORWARD',
          'mangle:INPUT',
          'mangle:OUTPUT',
          'mangle:POSTROUTING',
          'mangle:PREROUTING',
          'nat:INPUT',
          'nat:OUTPUT',
          'nat:POSTROUTING',
          'nat:PREROUTING',
          'raw:OUTPUT',
          'raw:PREROUTING',
          'security:FORWARD',
          'security:INPUT',
          'security:OUTPUT'
        ]
        type = "fluffy_chain"

      when :services
        type = 'fluffy_service'
        reserved << 'any'

      when :interfaces
        type = 'fluffy_interface'
        reserved << 'any'

      when :addressbook
        type = 'fluffy_address'
        reserved += ['any', 'any_broadcast']
    end

    Puppet::Type.type(type).instances.
      reject { |r| catalog.resource_refs.include?(r.ref) }.
      select { |r| !reserved.include?(r[:name]) }.
      select { |r| r.class.validproperty?(:ensure) }.
      select { |r| able_to_ensure_absent?(r) }.
      each do |resource|
        @parameters.each do |name, param|
          resource[name] = param.value if param.metaparam?
        end

        resource.purging
    end
  end
end
