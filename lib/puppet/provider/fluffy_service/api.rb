begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_service).provide(:api) do
  desc "Manage Fluffy services"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def self.instances
    instances = []
    services = session.services.get
    services.each do |name, service|
      instances << new(
        :name => name,
        :src_port => service['src_port'],
        :dst_port => service['dst_port'],
        :protocol => service['protocol'],
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
      session.services.add(name: resource[:name], src_port: resource[:src_port], dst_port: resource[:dst_port], protocol: resource[:protocol])
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    session.services.delete(name: resource[:name])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the getters for all properties
  mk_resource_methods

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def src_port=(value)
    @property_flush[:src_port] = value
  end

  def dst_port=(value)
    @property_flush[:dst_port] = value
  end

  def protocol=(value)
    @property_flush[:protocol] = value
  end

  def flush
    unless @property_flush.empty?
      begin
        session.services.update(name: resource[:name], **@property_flush)
      rescue ::Fluffy::APIError => e
        fail "#{e.message} (#{e.error})"
      end
    end
  end
end
