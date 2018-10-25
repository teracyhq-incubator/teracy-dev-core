require 'teracy-dev/logging'

module TeracyDevCore
  module Providers
    class Manager

      @@logger = TeracyDev::Logging.logger_for(self)
      @registry = {}

      class << self
        attr_reader :registry
      end

      def self.register(provider_type, provider_impl)
        if !provider_impl.respond_to?(:configure)
          @@logger.warn("provider #{provider_impl} must implement configure method, ignored")
          return
        end

        if @registry[provider_type].nil?
          @registry[provider_type] = [provider_impl]
        else
          @registry[provider_type] << provider_impl
        end
        @@logger.debug("#{provider_impl} with type: #{provider_type} registered")
        @@logger.debug("registry: #{@registry}")
      end
    end
  end
end
