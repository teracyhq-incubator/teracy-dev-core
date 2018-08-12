require 'teracy-dev'

require_relative 'teracy-dev-core/config/networks'
require_relative 'teracy-dev-core/config/plugins'
require_relative 'teracy-dev-core/config/provisioners'
require_relative 'teracy-dev-core/config/ssh'
require_relative 'teracy-dev-core/config/synced_folders'
require_relative 'teracy-dev-core/config/vgrant'
require_relative 'teracy-dev-core/config/virtualbox_provider'
require_relative 'teracy-dev-core/config/vm'
require_relative 'teracy-dev-core/config/winrm'
require_relative 'teracy-dev-core/config/winssh'

require_relative 'teracy-dev-core/processors/variables'


module TeracyDevCore
  def self.init
    TeracyDev.register_processor(TeracyDevCore::Processors::Variables.new)

    TeracyDev.register_configurator(TeracyDevCore::Config::Networks.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Plugins.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Provisioners.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::SSH.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::SyncedFolders.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Vgrant.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::VirtualBoxProvider.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::VM.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::WinRM.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::WinSSH.new)
  end
end

