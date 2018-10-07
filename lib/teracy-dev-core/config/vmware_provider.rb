require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/providers/
    class VMwareProvider < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        providers_settings = settings['providers'] ||= []

        providers_settings.each do |provider_settings|
          next if !provider_settings['enabled']
          case provider_settings['type']
          when "vmware_desktop"
            @logger.debug("provider_settings: #{provider_settings}")
            configure_vmware(provider_settings, config)
          end
        end
      end

      private

      def configure_vmware(provider_settings, config)
        options = provider_settings.dup

        ["_id", "type", "enabled"].each do |key|
          options.delete(key)
        end

        config.vm.provider "vmware_desktop" do |vmware|
          vmware.set_options(options)
        end
      end
    end
  end

end
