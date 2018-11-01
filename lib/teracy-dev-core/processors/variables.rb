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
          match_string = /\$\{(.*):\-(.*)?\}/.match(value.to_s)

          if !match_string
            match_string = /\$\{(.*)\}/.match(value.to_s)
          end

          if match_string
            match_group = match_string.captures

            env_value = ENV[match_group[0]]

            env_default = match_group[1]

            @logger.debug("KEY: #{key}, env_key: #{match_group[0]}, env_value: #{env_value}, env_default: #{env_default}")

            formatedValues[key.to_sym] = TeracyDev::Util.exist?(env_value) ? env_value : env_default
          else
            formatedValues[key.to_sym] = value
          end
        end if settings['variables']

        warning_for_unused_variables settings

        # see settings as a `sprintf-like formatting`
        # then inject values it and convert it back to YAML format
        settings = eval(settings.to_s % formatedValues)

        @logger.debug("processed settings: #{settings}")

        settings
      end

      private

      def warning_for_unused_variables settings
        return false if !TeracyDev::Util.exist? settings['variables']

        extension_name_list = settings['teracy-dev']['extensions'].map { |x|
          "#{TeracyDev::Extension::Manager.manifest(x)['name']}-path"
        }

        used_variable_list = settings['variables'].map { |k, v| k }

        unused_variable_list = []

        setting_str = settings.to_s

        used_variable_list.map { |variable|
          found = Regexp.new("\%\{#{variable}\}", 'm').match(setting_str)

          if found.nil? and !extension_name_list.include? variable
            unused_variable_list << variable
          end
        }

        if unused_variable_list.length > 0
          @logger.warn("#{unused_variable_list} are not used in settings, please make sure this is intended.")
        end
      end
    end
  end
end
