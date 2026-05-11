require 'teracy-dev/config/configurator'


require_relative '../compat'

module TeracyDevCore
  module Config
      class Compat < TeracyDev::Config::Configurator
        def configure_node(settings, config)
          TeracyDevCore::Compat.apply_vagrant_compat
        end
    end
  end
end
