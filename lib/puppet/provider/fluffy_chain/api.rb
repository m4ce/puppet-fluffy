begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_chain).provide(:api) do
  desc "Manage Fluffy chains"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def self.instances
    instances = []
    chains = session.chains.get
    chains.each do |table_name, table|
      table.each do |chain_name, chain|
        instances << new(
          :name => "#{table_name}:#{chain_name}",
          :chain => chain_name,
          :table => table_name.to_sym,
          :policy => chain['policy'],
          :ensure => :present
        )
      end
    end
    instances
  end

  def self.prefetch(resources)
    items = instances
    resources.each do |name, resource|
      if provider = items.find { |item| item.chain == resource[:chain] and item.table == resource[:table] }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    begin
      session.chains.add(name: resource[:chain], table: resource[:table], policy: resource[:policy])
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    begin
      session.chains.delete(name: resource[:chain], table: resource[:table])
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

  def policy=(value)
    @property_flush[:policy] = value
  end

  def flush
    unless @property_flush.empty?
      begin
        session.chains.update(name: resource[:chain], table: resource[:table], policy: @property_flush[:policy])
      rescue ::Fluffy::APIError => e
        fail "#{e.message} (#{e.error})"
      end
    end
  end
end
