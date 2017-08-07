begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_address).provide(:api) do
  desc "Manage the Fluffy addressbook"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def self.instances
    instances = []
    addressbook = session.addressbook.get
    addressbook.each do |name, address|
      instances << new(
        :name => name,
        :address => address,
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
      session.addressbook.add(name: resource[:name], address: resource[:address])
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    begin
      session.addressbook.delete(name: resource[:name])
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the getters for all properties
  mk_resource_methods

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def address=(value)
    @property_flush[:address] = value
  end

  def flush
    unless @property_flush.empty?
      begin
        session.addressbook.update(name: resource[:name], address: @property_flush[:address])
      rescue ::Fluffy::APIError => e
        fail "#{e.message} (#{e.error})"
      end
    end
  end
end
