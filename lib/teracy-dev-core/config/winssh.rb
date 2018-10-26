require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/winssh_settings.html
    class WinSSH < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        winssh_settings = settings['winssh'] || {}
        @logger.debug("configure_node: #{winssh_settings}")

        config.winssh.set_options(winssh_settings)
      end
    end
  end
end
