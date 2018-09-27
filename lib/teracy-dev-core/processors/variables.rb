require 'teracy-dev/processors/processor'
require 'teracy-dev/util'

module TeracyDevCore
  module Processors
    # variables processor
    class Variables < TeracyDev::Processors::Processor

      def process(settings)
        @logger.debug("process: #{settings['variables']}")

        formatedValues = {}

        settings['variables'].each do |key, value|
          match_string = /\$\{(.*):\-(.*)?\}/.match(value)

          if !match_string
            match_string = /\$\{(.*)\}/.match(value)
          end

          if match_string
            match_group = match_string.captures

            env_value = ENV[match_group[0]]

            env_default = match_group[1]

            @logger.debug("KEY: #{key}, env_key: #{match_group[0]}, env_value: #{env_value}, env_default: #{env_default}")

            formatedValues[key.to_sym] = TeracyDev::Util.exist?(env_value) ? env_value : env_default
          end
        end if settings['variables']

        # see settings as a `sprintf-like formatting`
        # then inject values it and convert it back to YAML format
        settings = eval(settings.to_s % formatedValues)

        @logger.debug("processed settings: #{settings}")

        settings
      end
    end
  end
end
