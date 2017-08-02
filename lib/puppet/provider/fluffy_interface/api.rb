begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_interface).provide(:api) do
  desc "Manage Fluffy interfaces"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def self.instances
    instances = []
    interfaces = session.interfaces.get
    interfaces.each do |name, interface|
      instances << new(
        :name => name,
        :interface => interface,
        :ensure => :present
      )
    end
    instances
  end

  def self.prefetch(resources)
    items = instances
    resources.each do |name, resource|
      if provider = items.find { |item| item.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    begin
      session.interfaces.add(name: resource[:name], interface: resource[:interface])
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    session.interfaces.delete(name: resource[:name])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the getters for all properties
  mk_resource_methods

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def interface=(value)
    @property_flush[:interface] = value
  end

  def flush
    unless @property_flush.empty?
      begin
        session.interfaces.update(name: resource[:name], interface: @property_flush[:interface])
      rescue ::Fluffy::APIError => e
        fail "#{e.message} (#{e.error})"
      end
    end
  end
end
