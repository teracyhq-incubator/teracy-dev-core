lib_dir = File.expand_path('./lib', __dir__)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'teracy-dev'
require 'teracy-dev-core'


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
