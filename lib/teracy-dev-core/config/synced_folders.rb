require 'teracy-dev/config/configurator'

module TeracyDevCore
  module Config
    # see: https://www.vagrantup.com/docs/synced-folders/
    class SyncedFolders < TeracyDev::Config::Configurator

      def configure_node(settings, config)
        synced_folders_settings = settings['vm']['synced_folders'] ||= []
        @logger.debug("configure_node: #{synced_folders_settings}")
        synced_folders_settings.each do |synced_folder|
          options = {}
          host = synced_folder['host']
          guest = synced_folder['guest']

          synced_folder.each do |key, val|
            next if ["_id", "host", "guest"].include?(key)
            options[key.to_sym] = val
          end

          @logger.debug("host: #{host}, guest: #{guest}, options: #{options}")

          config.vm.synced_folder host, guest, options
        end
      end
    end
  end
end
