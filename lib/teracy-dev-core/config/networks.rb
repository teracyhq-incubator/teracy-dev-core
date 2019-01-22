require 'teracy-dev/config/configurator'
require 'teracy-dev/util'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/networking/
    class Networks < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        networks_settings = settings['vm']['networks']

        configure_networks(settings['_id'], networks_settings, config)
      end

      private

      def configure_networks(node_id, networks_settings, config)
        networks_settings ||= []
        @logger.debug("configure_networks: #{networks_settings}")
        networks_settings.each do |vm_network|
          # mode is deprecated, see: https://github.com/teracyhq-incubator/teracy-dev-core/issues/9
          network_type = vm_network['type'] || vm_network['mode']
          if TeracyDev::Util.exist? vm_network['mode']
            @logger.warn("'mode' is deprecated, use 'type' instead for networks")
          end

          network_id = vm_network['_id']

          id = "#{node_id}-#{network_type}-#{network_id}"

          if network_type == 'forwarded_port'
            forwarded_ports = vm_network['forwarded_ports']

            if !forwarded_ports.nil?
              @logger.warn("{type: forwarded_port, forwarded_ports: [...]} is deprecated, use {type: forwarded_port, host: ..., guest:...} instead for #{vm_network}")

              forwarded_ports.each do |item|
                item_id = "#{id}-#{item['_id']}"

                config.vm.network :forwarded_port, guest: item['guest'], host: item['host'], id: item_id
              end
            else
              config.vm.network :forwarded_port, guest: vm_network['guest'], host: vm_network['host'], id: id
            end
          else
            options = {
              id: id
            }
            case network_type
            when 'private_network'
              options[:ip] = vm_network['ip'] unless vm_network['ip'].nil? or vm_network['ip'].strip().empty?
              if options[:ip].nil? or options[:ip].empty?
                # make `type: 'dhcp'` default when `ip` is not defined (nil or empty)
                options[:type] = 'dhcp'
              else
                options[:auto_config] = !(vm_network['auto_config'] == false)
              end
            when 'public_network'
              options[:ip] = vm_network['ip'] unless vm_network['ip'].nil? or vm_network['ip'].strip().empty?
              options[:bridge] = vm_network['bridge'] unless vm_network['bridge'].nil? or vm_network['bridge'].empty?
            end
            config.vm.network network_type, options
          end
        end
      end

    end
  end
end
