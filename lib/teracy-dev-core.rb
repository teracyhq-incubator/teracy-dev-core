require 'teracy-dev'

require_relative 'teracy-dev-core/config/networks'
require_relative 'teracy-dev-core/config/plugins'
require_relative 'teracy-dev-core/config/provisioners'
require_relative 'teracy-dev-core/config/ssh'
require_relative 'teracy-dev-core/config/synced_folders'
require_relative 'teracy-dev-core/config/vgrant'
require_relative 'teracy-dev-core/config/provider'
require_relative 'teracy-dev-core/config/vm'
require_relative 'teracy-dev-core/config/winrm'
require_relative 'teracy-dev-core/config/winssh'

require_relative 'teracy-dev-core/processors/extension_path'
require_relative 'teracy-dev-core/processors/unused_variables'
require_relative 'teracy-dev-core/processors/variables'

require_relative 'teracy-dev-core/providers/virtualbox'
require_relative 'teracy-dev-core/providers/vmware'
require_relative 'teracy-dev-core/providers/docker'

module TeracyDevCore
  def self.init
    TeracyDev.register_processor(TeracyDevCore::Processors::UnusedVariables.new, weight = 2)
    TeracyDev.register_processor(TeracyDevCore::Processors::ExtensionPath.new, weight = 2)
    TeracyDev.register_processor(TeracyDevCore::Processors::Variables.new, weight = 1)

    TeracyDev.register_configurator(TeracyDevCore::Config::VM.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Networks.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Plugins.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Provisioners.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::SSH.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::SyncedFolders.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Vgrant.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::Provider.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::WinRM.new)
    TeracyDev.register_configurator(TeracyDevCore::Config::WinSSH.new)

    self.register_provider("virtualbox", TeracyDevCore::Providers::VirtualBox.new)
    self.register_provider("vmware_desktop", TeracyDevCore::Providers::VMware.new)
    self.register_provider("docker", TeracyDevCore::Providers::Docker.new)
  end

  # Register one or more provider implementations for a type
  # Providers must implement the method: configure(provider_settings, node_config) signature
  #
  # @since v0.4.0
  # see: https://github.com/teracyhq-incubator/teracy-dev-core/issues/33
  def self.register_provider(type, provider)
    Providers::Manager.register(type, provider)
  end
end
