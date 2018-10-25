require 'teracy-dev/logging'

module TeracyDevCore
  module Providers
    class Manager

      @@logger = TeracyDev::Logging.logger_for(self)
      @registry = {}

      class << self
        attr_reader :registry
      end

      def self.register(type, provider)
        if !provider.respond_to?(:configure)
          @@logger.warn("provider #{provider} must implement configure method, ignored")
          return
        end

        if @registry[type].nil?
          @registry[type] = [provider]
        else
          @registry[type] << provider
        end
        @@logger.debug("#{provider} with type: #{type} registered")
        @@logger.debug("registry: #{@registry}")
      end
    end
  end
end
