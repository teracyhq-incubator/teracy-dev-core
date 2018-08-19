require 'teracy-dev/processors/processor'

module TeracyDevCore
  module Processors
    # variables processor
    class Variables < TeracyDev::Processors::Processor

      def process(settings)
        @logger.debug("process: #{settings['variables']}")

        # see `settings['variables']` as a template, then load it using `envsubst`
        variables = `envsubst <<< "#{settings['variables']}"`

        # the output is a YAML string, load it then override the origin setting
        settings['variables'] = YAML.load(variables)

        settings
      end
    end
  end
end
