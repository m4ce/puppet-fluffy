require 'fluffy/client' if Puppet.features.fluffy_api?

module PuppetX
  module Fluffy
    module API
      @@client = nil
      @@session = nil

      def session
        return @@session if @@session

        begin
          @@client = ::Fluffy::Client.new(url: ENV['FLUFFY_API_URL'] || "http://localhost:8676", version: ENV['FLUFFY_API_VERSION'] || 1)
          @@session = @@client.sessions.add(name: 'puppet', owner: 'puppet', ttl: 300)
        rescue Errno::ENETUNREACH
          fail "Failed to connect to Fluffy API"
        rescue ::Fluffy::APIError => e
          # Session already exists?
          if e.code == 409
            @@client.sessions.delete(name: 'puppet')
            retry
          else
            fail "#{e.message} (#{e.error})"
          end
        end

        @@session
      end
    end
  end
end
