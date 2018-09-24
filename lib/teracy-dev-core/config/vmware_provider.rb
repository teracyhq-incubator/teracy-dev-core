require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/providers/
    class VMwareProvider < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        providers_settings = settings['providers'] ||= []

        providers_settings.each do |provider_settings|
          if provider_settings['type'].include?('vmware')
            @logger.debug("provider_settings: #{provider_settings}")
            configure_vmware(provider_settings, config) if provider_settings['enabled'] == true
          end
        end
      end

      private

      def configure_vmware(provider_settings, config)
        config.vm.provider provider_settings['type'] do |vmware|
          vmware.gui = true if provider_settings['gui'] == true

          provider_settings.each do |key, val|
            if provider_settings[key] == "vmx" and !provider_settings[key].nil?
              provider_settings['vmx'].each do |vmx_key, vmx_val|
                vmx_val = vmx_val.to_s.strip()
                if !vmx_val.empty?
                  vmware.vmx["#{vmx_key}"] = vmx_val
                end
              end
            else
              val = val.to_s.strip()
              if !val.empty?
                vmware.provider_settings[key] = val
              end
            end
          end
        end
      end
    end
  end

end
