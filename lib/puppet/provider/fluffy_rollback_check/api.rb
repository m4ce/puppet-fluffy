begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_rollback_check).provide(:api) do
  desc "Manage Fluffy rollback checks"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def self.instances
    instances = []
    checks = session.rollback_checks.get
    checks.each do |name, check|
      instances << new(
        :name => name,
        :command => check['command'],
        :host => check['host'],
        :port => check['port'],
        :timeout => check['timeout'],
        :type => check['type'],
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
      session.rollback_checks.add(name: resource[:name], type: resource[:type], host: resource[:host], port: resource[:port], timeout: resource[:timeout], command: resource[:command])
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    session.rollback_checks.delete(name: resource[:name])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the getters for all properties
  mk_resource_methods

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def type=(value)
    @property_flush[:type] = value
  end

  def host=(value)
    @property_flush[:host] = value
  end

  def port=(value)
    @property_flush[:port] = value
  end

  def command=(value)
    @property_flush[:command] = value
  end

  def timeout=(value)
    @property_flush[:timeout] = value
  end

  def flush
    unless @property_flush.empty?
      begin
        session.rollback_checks.update(name: resource[:name], **@property_flush)
      rescue ::Fluffy::APIError => e
        fail "#{e.message} (#{e.error})"
      end
    end
  end
end
