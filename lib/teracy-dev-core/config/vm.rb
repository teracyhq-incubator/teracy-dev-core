require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # set configuration for VM from the vm provided vm settings hash
    # see: https://www.vagrantup.com/docs/vagrantfile/machine_settings.html
    class VM < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        vm_settings = settings['vm'] || {}
        # exclude networks and synced_folders for this general vm config
        ["networks", "synced_folders"].each do |key|
          vm_settings.delete(key)
        end
        @logger.debug("configure_node: #{vm_settings}")
        if !vm_settings['usable_port_range'].nil?
          ranges = vm_settings['usable_port_range'].split('..').map{|d| Integer(d)}
          vm_settings["usable_port_range"] = ranges[0]..ranges[1]
        end
        config.vm.set_options(vm_settings)
      end
    end
  end
end
