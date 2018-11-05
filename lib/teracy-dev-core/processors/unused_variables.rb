require 'teracy-dev/processors/processor'

module TeracyDevCore
  module Processors
    # variables processor
    class UnusedVariables < TeracyDev::Processors::Processor

      def process(settings)
        @logger.debug("checking: #{settings['variables']}")

        used_variable_list = settings['variables'].map { |k, v| k }

        unused_variable_list = []

        setting_str = settings.to_s

        used_variable_list.map { |variable|
          found = Regexp.new("\%\{#{variable}\}", 'm').match(setting_str)

          if found.nil?
            unused_variable_list << variable
          end
        }

        if unused_variable_list.length > 0
          @logger.warn("#{unused_variable_list} are not used in settings, please make sure this is intended.")
        end

        settings
      end
    end
  end
end
