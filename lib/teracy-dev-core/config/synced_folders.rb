require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/synced-folders/
    class SyncedFolders < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        synced_folders_settings = settings['vm']['synced_folders'] ||= []
        @logger.debug("configure_node: #{synced_folders_settings}")

        synced_folders_settings.each do |settings|
          settings['type'] = settings['type'] ||= 'virtual_box'
          host = settings['host']
          guest = settings['guest']

          ['host', 'guest'].each do |key|
            settings.delete(key)
          end

          settings.each do |key, val|
            settings[key.to_sym] = val
            settings.delete(key)
          end

          config.vm.synced_folder host, guest, settings
        end
      end
    end
  end
end
