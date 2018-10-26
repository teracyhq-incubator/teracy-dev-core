require 'teracy-dev'
require 'teracy-dev/util'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/provisioning/
    class Provisioners < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        provisioners_settings = settings['provisioners'] ||= []

        TeracyDev::Util.multi_sort(to_items(provisioners_settings), weight: :desc, id: :asc).each do |item|
          provisioner_settings = item[:provisioner_settings]
          @logger.debug("provisioner_settings: #{provisioner_settings}")

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

          ["_id", "type", "enabled", "run", "preserve_order", "weight"].each do |key|
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

      private

      def to_items(provisioners_settings)
        @logger.debug("provisioners_settings: #{provisioners_settings}")
        items = []
        provisioners_settings.each_with_index do |provisioner_settings, index|
          if provisioner_settings.has_key?('weight')
            weight = provisioner_settings['weight']
          else
            # default to 5 if no set
            weight = 5
          end

          unless weight.is_a? Integer and (0..9).include?(weight)
            @logger.warn("#{provisioner_settings}'s weight (#{weight}) must be an integer and have value in range (0..9), otherwise it will be set to default (5)")
            weight = 5
          end
          items << { provisioner_settings: provisioner_settings, id: index, weight: weight }
        end
        @logger.debug("items: #{items}")
        items
      end

    end
  end
end
