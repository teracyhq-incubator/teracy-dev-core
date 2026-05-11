module TeracyDevCore
  module Compat
    # Shared helper for Ruby 2 -> Ruby 3 keyword argument compatibility.
    #
    # Ruby 2 implicitly converted the last Hash argument into keyword arguments,
    # while Ruby 3 requires explicit keyword arguments (`**kwargs`).
    #
    # This helper restores the Ruby 2 behavior by extracting the last positional
    # Hash argument and treating it as keyword arguments when no explicit kwargs
    # are provided.
    module KeywordArgsCompat
      private

      def extract_kwargs(args, kwargs)
        # Keep explicitly passed keyword arguments untouched.
        return kwargs unless kwargs.empty?

        # Only convert the last positional argument when it is a Hash.
        return {} unless args.last.is_a?(Hash)

        # Remove the Hash from positional args and use it as kwargs.
        args.pop
      end
    end

    # Compatibility shim for:
    #   VagrantPlugins::Kernel_V2::VMConfig#network
    #
    # Some older Vagrant plugins still call:
    #
    #   network(:private_network, { ip: "192.168.50.4" })
    #
    # which worked in Ruby 2 but breaks in Ruby 3 because the Hash is no longer
    # automatically converted into keyword arguments.
    #
    # This shim transparently restores the old behavior.
    module ConfigVMShim
      include KeywordArgsCompat

      def network(type, *args, **kwargs)
        kwargs = extract_kwargs(args, kwargs)

        super(type, *args, **kwargs)
      end
    end

    # Compatibility shim for:
    #   Vagrant::Plugin::Manager#install_plugin
    #
    # Older plugin installation code may pass plugin options as a positional
    # Hash instead of keyword arguments. This shim converts the trailing Hash
    # into kwargs for Ruby 3 compatibility.
    module PluginManagerShim
      include KeywordArgsCompat

      def install_plugin(name, *args, **kwargs)
        kwargs = extract_kwargs(args, kwargs)

        super(name, **kwargs)
      end
    end

    # Apply Ruby keyword-argument compatibility patches to Vagrant internals.
    #
    # This method:
    #   1. Attempts to load VMConfig dynamically if it is not already loaded.
    #   2. Prepends compatibility shims only once.
    #
    # Using `prepend` allows us to intercept method calls while still delegating
    # to the original implementation via `super`.
    def self.apply_vagrant_compat
      # Try to load VM config if not already loaded.
      if !defined?(VagrantPlugins::Kernel_V2::VMConfig)
        vm_config_path = find_vagrant_vm_config_path

        if vm_config_path && File.exist?(vm_config_path)
          begin
            load vm_config_path
          rescue => e
            # Ignore loading errors because Vagrant installations vary
            # between environments and packaging methods.
          end
        end
      end

      # Inject network compatibility shim.
      if defined?(VagrantPlugins::Kernel_V2::VMConfig)
        VagrantPlugins::Kernel_V2::VMConfig.prepend(ConfigVMShim) unless
          VagrantPlugins::Kernel_V2::VMConfig < ConfigVMShim
      end

      # Inject plugin manager compatibility shim.
      if defined?(Vagrant::Plugin::Manager)
        Vagrant::Plugin::Manager.prepend(PluginManagerShim) unless
          Vagrant::Plugin::Manager < PluginManagerShim
      end
    end

    # Try to locate Vagrant's internal VM config implementation file.
    #
    # Different Vagrant distributions place files in different locations:
    #   - RubyGems installation
    #   - Embedded HashiCorp package
    #   - System package manager
    #
    # Returns:
    #   Absolute path to vm.rb if found, otherwise nil.
    def self.find_vagrant_vm_config_path
      # Try locating via RubyGems specification first.
      begin
        vagrant_spec = Gem::Specification.find_by_name('vagrant')

        path = File.join(
          vagrant_spec.gem_dir,
          'plugins',
          'kernel_v2',
          'config',
          'vm.rb'
        )

        return path if File.exist?(path)
      rescue Gem::MissingSpecificationError
        # Vagrant may be embedded instead of installed as a gem.
      end

      # Fallback to common embedded installation paths.
      vagrant_version = Vagrant::VERSION

      possible_paths = [
        "/opt/vagrant/embedded/gems/gems/vagrant-#{vagrant_version}/plugins/kernel_v2/config/vm.rb",
        "/opt/vagrant/embedded/gems/gems/vagrant-#{vagrant_version}/lib/vagrant/plugins/kernel_v2/config/vm.rb",
      ]

      possible_paths.each do |path|
        return path if File.exist?(path)
      end

      nil
    end
  end
end
