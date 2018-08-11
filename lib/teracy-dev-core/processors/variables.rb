require 'teracy-dev/processors/processor'

module TeracyDevCore
  module Processors
    # variables processor
    class Variables < TeracyDev::Processors::Processor

      def process(settings)
        @logger.debug("process: #{settings}")
        settings
      end
    end
  end
end
