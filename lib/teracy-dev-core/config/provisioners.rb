require 'teracy-dev'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/provisioning/
    class Provisioners < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        provisioners_settings = settings['provisioners'] || []
        @logger.debug("provisioners_settings: #{provisioners_settings}")
        provisioners_settings.each do |provisioner_settings|
          @logger.info("provisioner ignored: #{provisioner_settings}") if provisioner_settings['enabled'] != true
          next if provisioner_settings['enabled'] != true

          type = provisioner_settings['type']
          run = 'once'
          preserve_order = false
          if !provisioner_settings['run'].nil?
            run = provisioner_settings['run'] # one of: once, always, or never
          end
          if provisioner_settings['preserve_order'] == true
            preserve_order = true
          end

          options = provisioner_settings.dup

          ["_id", "type", "enabled", "run", "preserve_order"].each do |key|
            options.delete(key)
          end

          if provisioner_settings['name'].nil?
            config.vm.provision "#{type}", run: run, preserve_order: preserve_order do |provision|
              provision.set_options(options)
            end
          else
            config.vm.provision provisioner_settings['name'], type: type, run: run, preserve_order: preserve_order do |provision|
              provision.set_options(options)
            end
          end
        end
      end
    end
  end
end
