require 'teracy-dev/config/configurator'

require_relative '../providers/manager'

module TeracyDevCore
  module Config
    class Provider < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        registry = Providers::Manager.registry
        providers_settings = settings['providers'] || []
        @logger.debug("providers_settings: #{providers_settings}")

        providers_settings.each do |provider_settings|
          next if !provider_settings['enabled']
          providers = registry[provider_settings['type']]

          if providers.nil? || providers.empty?
            @logger.warn("not any provider with the type of #{provider_settings['type']} is registered")
            next
          end

          providers.each do |provider|
            provider.configure(provider_settings, config)
          end
        end
      end
    end
  end
end
