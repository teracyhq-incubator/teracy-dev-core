require 'teracy-dev/config/configurator'
require 'teracy-dev/util'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/ssh_settings.html
    class SSH < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        ssh_settings = settings['ssh'] || {}
        @logger.debug("configure_node: #{ssh_settings}")
        config.ssh.set_options(ssh_settings)
      end
    end
  end
end
