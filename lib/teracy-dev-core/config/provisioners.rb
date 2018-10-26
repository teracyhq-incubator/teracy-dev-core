require 'teracy-dev'
require 'teracy-dev/util'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/provisioning/
    class Provisioners < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        provisioners_settings = settings['provisioners'] ||= []
        TeracyDev::Util.multi_sort(convert_data_to_sort(provisioners_settings), weight: :desc, _id: :asc).each do |provisioner_settings|
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

          [:"_id", "type", "enabled", "run", "preserve_order", :"weight"].each do |key|
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

      def convert_data_to_sort(provisioners_settings)
        items = provisioners_settings.map do |index|
          unless index.has_key?('weight') and (0..9).include?(index['weight']) and index['weight'].is_a? Integer
            @logger.warn("provisioner's weight must be an integer and have value in range (0..9), otherwise it will be set to default (5)")
            index['weight'] = 5
          end

          index.each_with_object({}) do |(k,v),h|
            if k == '_id' || k == 'weight'
              h[k.to_sym] = v
            else
              h[k] = v
            end
          end
        end

        items
      end

    end
  end
end
