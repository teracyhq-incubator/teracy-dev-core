require 'teracy-dev/logging'

module TeracyDevCore
  module Providers
    # the base class for Provider to extend
    class Provider
      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end

      # provider must implement this to execute actual configuration
      def configure(provider_settings, node_config)

      end
    end
  end
end
