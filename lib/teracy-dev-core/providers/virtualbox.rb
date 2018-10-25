require_relative 'provider'

module TeracyDevCore
  module Providers
    # see: https://www.vagrantup.com/docs/virtualbox/
    class VirtualBox < TeracyDevCore::Providers::Provider

      def configure(provider_settings, node_config)
        # remove any words after the main version
        # example: 5.1.14r1 => 5.1.141
        # current_version = `VBoxManage --version`.gsub /[a-zA-Z]/, ''
        current_version = "#{VagrantPlugins::ProviderVirtualBox::Driver::Meta.new.version}".gsub /[a-zA-Z]/, ''

        if !TeracyDev::Util.require_version_valid?(current_version,
            provider_settings['require_version'])
          @logger.error("Your current virtualbox (#{current_version}) is not up to date.\
            The required version is #{provider_settings['require_version']}.
            Please upgrade it to the required version then run `VBoxManage --version` to check.".squeeze)

          abort
        end
        configure_virtualbox(provider_settings, node_config)
      end

      private

      def configure_virtualbox(provider_settings, config)
        config.vm.provider "virtualbox" do |vb|
          vb.gui = true if provider_settings['gui'] == true

          general_settings_keys = ['name', 'groups', 'description', 'ostype', 'memory', 'vram', 'acpi',
            'ioapic', 'hardwareuuid', 'cpus', 'rtcuseutc', 'cpuhotplug', 'plugcpu', 'unplugcpu',
            'cpuexecutioncap', 'pae', 'longmode', 'synthcpu', 'hpet', 'hwvirtex', 'triplefaultreset',
            'nestedpaging', 'largepages', 'vtxvpid', 'vtxux', 'accelerate3d', 'bioslogofadein',
            'bioslogodisplaytime', 'bioslogoimagepath', 'biosbootmenu', 'snapshotfolder', 'firmware',
            'guestmemoryballoon', 'defaultfrontend'
          ]

          provider_settings.each do |key, val|
            if general_settings_keys.include?(key) and !provider_settings[key].nil?
              val = val.to_s.strip()
              if !val.empty?
                vb.customize ["modifyvm", :id, "--" + key, val]
              end
            end
          end
        end
      end
    end
  end

end
