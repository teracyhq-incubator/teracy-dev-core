require 'teracy-dev/processors/processor'

module TeracyDevCore
  module Processors
    # variables processor
    class Variables < TeracyDev::Processors::Processor

      def process(settings)
        @logger.debug("process: #{settings['variables']}")

        formatedValues = {}

        settings['variables'].each do |key, value|
          formatedValues[key.to_sym] = `echo #{value}`.strip
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
