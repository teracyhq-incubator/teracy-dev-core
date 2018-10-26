require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/winrm_settings.html
    class WinRM < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        winrm_settings = settings['winrm'] || {}
        @logger.debug("configure_node: #{winrm_settings}")

        config.winrm.set_options(winrm_settings)
      end
    end
  end
end
