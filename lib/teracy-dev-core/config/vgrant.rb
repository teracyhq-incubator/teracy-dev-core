require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/vagrant_settings.html
    class Vgrant < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        vagrant_settings = settings['vagrant'] ||= {}

        @logger.debug("configure_node: #{vagrant_settings}")

        config.vagrant.set_options(vagrant_settings)
      end
    end
  end
end
