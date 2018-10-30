require_relative 'provider'

module TeracyDevCore
  module Providers
    # see: https://www.vagrantup.com/docs/docker/
    class Docker < TeracyDevCore::Providers::Provider

      def configure(provider_settings, node_config)
        node_config.vm.provider "docker" do |docker|
          docker.set_options(provider_settings)
        end
      end
    end
  end
end
