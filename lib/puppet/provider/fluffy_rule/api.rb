begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_rule).provide(:api) do
  desc "Manage Fluffy rules"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def self.instances
    instances = []
    rules = session.rules.get
    rules.each do |name, rule|
      instances << new(
        # name is defined as <table>_<chain>_<rule_name>. We are only interested in <rule_name> here.
        :name => name.split('_', 3)[1],
        :table => rule['table'],
        :chain => rule['chain'],
        :action => rule['action'] ? rule['action'] : nil,
        :jump => rule['jump'] || nil,
        :negate_protocol => rule['negate_protocol'],
        :protocol => rule['protocol'] || nil,
        :negate_icmp_type => rule['negate_icmp_type'],
        :icmp_type => rule['icmp_type'] || nil,
        :negate_tcp_flags => rule['negate_tcp_flags'],
        :tcp_flags => rule['tcp_flags'],
        :negate_ctstate => rule['negate_ctstate'],
        :ctstate => rule['ctstate'],
        :negate_state => rule['negate_state'],
        :state => rule['state'],
        :negate_src_address_range => rule['negate_src_address_range'],
        :src_address_range => rule['src_address_range'],
        :negate_dst_address_range => rule['negate_dst_address_range'],
        :dst_address_range => rule['dst_address_range'],
        :negate_in_interface => rule['negate_in_interface'],
        :in_interface => rule['in_interface'] || nil,
        :negate_out_interface => rule['negate_out_interface'],
        :out_interface => rule['out_interface'] || nil,
        :negate_src_address => rule['negate_src_address'],
        :src_address => rule['src_address'],
        :negate_dst_address => rule['negate_dst_address'],
        :dst_address => rule['dst_address'],
        :negate_src_service => rule['negate_src_service'],
        :negate_dst_service => rule['negate_dst_service'],
        :src_service => rule['src_service'],
        :dst_service => rule['dst_service'],
        :reject_with => rule['reject_with'] || nil,
        :set_mss => rule['set_mss'] || nil,
        :clamp_mss_to_pmtu => rule['clamp_mss_to_pmtu'],
        :to_src => rule['to_src'],
        :to_dst => rule['to_dst'],
        :limit => rule['limit'],
        :limit_burst => rule['limit_burst'],
        :log_prefix => rule['log_prefix'],
        :log_level => rule[':log_level'],
        :comment => rule['comment'],
        :ensure => :present
      )
    end
    instances
  end

  def self.prefetch(resources)
    items = instances
    resources.each do |name, resource|
      if provider = items.find { |item| item.name == name and item.table == resource[:table] and item.chain == resource[:chain] }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    begin
      rule = {
        :table => resource[:table],
        :chain => resource[:chain],
        :action => resource[:action] != :absent ? resource[:action] : nil,
        :jump => resource[:jump] != :absent ? resource[:jump] : nil,
        :negate_protocol => resource[:negate_protocol],
        :protocol => resource[:protocol] != :absent ? resource[:protocol] : nil,
        :negate_icmp_type => resource[:negate_icmp_type],
        :icmp_type => resource[:icmp_type] != :absent ? resource[:icmp_type] : nil,
        :negate_tcp_flags => resource[:negate_tcp_flags],
        :tcp_flags => resource[:tcp_flags] != :absent ? resource[:tcp_flags] : nil,
        :negate_ctstate => resource[:negate_ctstate],
        :ctstate => resource[:ctstate],
        :negate_state => resource[:negate_state],
        :state => resource[:state],
        :negate_src_address_range => resource[:negate_src_address_range],
        :src_address_range => resource[:src_address_range],
        :negate_dst_address_range => resource[:negate_dst_address_range],
        :dst_address_range => resource[:dst_address_range],
        :negate_in_interface => resource[:negate_in_interface],
        :in_interface => resource[:in_interface],
        :negate_out_interface => resource[:negate_out_interface],
        :out_interface => resource[:out_interface],
        :negate_src_address => resource[:negate_src_address],
        :src_address => resource[:src_address],
        :negate_dst_address => resource[:negate_dst_address],
        :dst_address => resource[:dst_address],
        :negate_src_service => resource[:negate_src_service],
        :src_service => resource[:src_service],
        :negate_dst_service => resource[:negate_dst_service],
        :dst_service => resource[:dst_service],
        :reject_with => resource[:reject_with] != :absent ? resource[:reject_with] : nil,
        :set_mss => resource[:set_mss] != :absent ? resource[:set_mss] : nil,
        :clamp_mss_to_pmtu => resource[:clamp_mss_to_pmtu],
        :to_src => resource[:to_src] != :absent ? resource[:to_src] : nil,
        :to_dst => resource[:to_dst] != :absent ? resource[:to_dst] : nil,
        :limit => resource[:limit] != :absent ? resource[:limit] : nil,
        :limit_burst => resource[:limit_burst] != :absent ? resource[:limit_burst] : nil,
        :log_prefix => resource[:log_prefix] != :absent ? resource[:log_prefix] : nil,
        :log_level => resource[:log_level] != :absent ? resource[:log_level] : nil,
        :comment => resource[:comment] != :absent ? resource[:comment] : nil
      }

      if resource[:before_rule]
        rule[:before_rule] = resource[:before_rule]
      elsif resource[:after_rule]
        rule[:after_rule] = resource[:after_rule]
      end

      session.rules.add(name: "#{resource[:table]}_#{resource[:chain].downcase}_#{resource[:name]}", **rule)
    rescue ::Fluffy::APIError => e
      fail "#{e.message} (#{e.error})"
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    session.rules.delete(name: "#{resource[:table]}_#{resource[:chain].downcase}_#{resource[:name]}")
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the getters for all properties
  mk_resource_methods

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def action=(value)
    @property_flush[:action] = (value != :absent) ? value : nil
  end

  def jump=(value)
    @property_flush[:jump] = (value != :absent) ? value : nil
  end

  def negate_protocol=(value)
    @property_flush[:negate_protocol] = value
  end

  def protocol=(value)
    @property_flush[:negate_protocol] = (value != :absent) ? value : nil
  end

  def icmp_type=(value)
    @property_flush[:icmp_type] = (value != :absent) ? value : nil
  end

  def negate_icmp_type=(value)
    @property_flush[:negate_icmp_type] = value
  end

  def tcp_flags=(value)
    @property_flush[:tcp_flags] = (value != :absent) ? value : nil
  end

  def negate_tcp_flags=(value)
    @property_flush[:negate_tcp_flags] = value
  end

  def ctstate=(value)
    @property_flush[:ctstate] = value
  end

  def negate_ctstate=(value)
    @property_flush[:negate_ctstate] = value
  end

  def state=(value)
    @property_flush[:state] = value
  end

  def negate_state=(value)
    @property_flush[:negate_state] = value
  end

  def src_address_range=(value)
    @property_flush[:src_address_range] = value
  end

  def negate_src_address_range=(value)
    @property_flush[:negate_src_address_range] = value
  end

  def dst_address_range=(value)
    @property_flush[:dst_address_range] = value
  end

  def negate_dst_address_range=(value)
    @property_flush[:negate_dst_address_range] = value
  end

  def in_interface=(value)
    @property_flush[:in_interface] = value
  end

  def negate_in_interface=(value)
    @property_flush[:negate_in_interface] = value
  end

  def out_interface=(value)
    @property_flush[:out_interface] = value
  end

  def negate_out_interface=(value)
    @property_flush[:negate_out_interface] = value
  end

  def negate_src_address=(value)
    @property_flush[:negate_src_address] = value
  end

  def src_address=(value)
    @property_flush[:src_address] = value
  end

  def negate_dst_address=(value)
    @property_flush[:negate_dst_address] = value
  end

  def dst_address=(value)
    @property_flush[:dst_address] = value
  end

  def src_service=(value)
    @property_flush[:src_service] = value
  end

  def negate_src_service=(value)
    @property_flush[:negate_src_service] = value
  end

  def dst_service=(value)
    @property_flush[:dst_service] = value
  end

  def negate_dst_service=(value)
    @property_flush[:negate_dst_service] = value
  end

  def reject_with=(value)
    @property_flush[:reject_with] = (value != :absent) ? value : nil
  end

  def set_mss=(value)
    @property_flush[:set_mss] = (value != :absent) ? value : nil
  end

  def clamp_mss_to_pmtu=(value)
    @property_flush[:clamp_mss_to_pmtu] = value
  end

  def to_src=(value)
    @property_flush[:to_src] = (value != :absent) ? value : nil
  end

  def to_dst=(value)
    @property_flush[:to_dst] = (value != :absent) ? value : nil
  end

  def limit=(value)
    @property_flush[:limit] = (value != :absent) ? value : nil
  end

  def limit_burst=(value)
    @property_flush[:limit_burst] = (value != :absent) ? value : nil
  end

  def log_prefix=(value)
    @property_flush[:log_prefix] = (value != :absent) ? value : nil
  end

  def log_level=(value)
    @property_flush[:log_level] = (value != :absent) ? value : nil
  end

  def comment=(value)
    @property_flush[:comment] = (value != :absent) ? value : nil
  end

  def flush
    unless @property_flush.empty?
      begin
        session.rules.update(name: resource[:name], **@property_flush)
      rescue ::Fluffy::APIError => e
        fail "#{e.message} (#{e.error})"
      end
    end
  end
end
