require 'teracy-dev/processors/processor'
require 'teracy-dev/util'

module TeracyDevCore
  module Processors
    # variables processor
    class ExtensionPath < TeracyDev::Processors::Processor

      def process(settings)
        settings['variables'] = settings['variables'] || []
        # Export extensions path to variables
        settings['teracy-dev']['extensions'].each do |extension|
          next if extension['enabled'] != true
          manifest = TeracyDev::Extension::Manager.manifest(extension)
          extension_base_path = File.join(extension['path']['lookup'] || TeracyDev::DEFAULT_EXTENSION_LOOKUP_PATH, extension['path']['extension'])
          settings['variables']["#{manifest['name']}-path"] = extension_base_path
        end if settings['teracy-dev'] && settings['teracy-dev']['extensions']
        @logger.debug("exported extensions path to setting variable: #{settings['variables']}")
        settings
      end
    end
  end
end
