require_relative 'provider'

module TeracyDevCore
  module Providers
    # see: https://www.vagrantup.com/docs/vmware/
    class VMware < TeracyDevCore::Providers::Provider

      def configure(provider_settings, node_config)
        node_config.vm.provider "vmware_desktop" do |vmware|
          vmware.set_options(provider_settings)
        end
      end
    end
  end
end
