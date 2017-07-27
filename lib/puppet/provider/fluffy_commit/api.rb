begin
  require 'puppet_x/fluffy/api'
rescue LoadError => detail
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../puppet_x/fluffy/api'
end

Puppet::Type.type(:fluffy_commit).provide(:api) do
  desc "Manage the Fluffy commit process"

  confine :feature => :fluffy_api

  # Mix in the api as instance methods
  include PuppetX::Fluffy::API

  # Mix in the api as class methods
  extend PuppetX::Fluffy::API

  def commit
    begin
      session.commit!(rollback: @resource[:rollback], rollback_interval: @resource[:rollback_interval])
    rescue ::Fluffy::APIError => e
      fail "#{e.message}: #{e.error}"
    end
  end
end
