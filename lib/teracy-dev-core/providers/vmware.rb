require_relative 'provider'

module TeracyDevCore
  module Providers
    # see: https://www.vagrantup.com/docs/vmware/
    class VMware < TeracyDevCore::Providers::Provider

      def configure(provider_settings, node_config)
        options = provider_settings.dup

        ["_id", "type", "enabled"].each do |key|
          options.delete(key)
        end

        node_config.vm.provider "vmware_desktop" do |vmware|
          vmware.set_options(options)
        end

      end
    end
  end
end
