module Impressbox
  module Middlewares

    # Installs plugins
    class PluginHostmanager < Impressbox::Abstract::Middleware

      # Call method of middleware
      #
      #@param env [Hash]  Current hash used for invoking this middleware
      def call(env)
        method(env[:action_name]).call env
      end

      # Get hook when to add
      #
      #@return [Array]
      def self.hooks
        [
          [:append, :machine_up],
          [:append, :machine_halt],
        ]
      end

      # Action executed when configuring
      #
      #@param env [Hash] Enviroment
      def impressbox_configure(env)
        require 'vagrant-hostmanager'

        hostname, aliases = extract_data(env[:config_file])

        @app.vm.hostname = hostname
        configure_hostmanager @app.hostmanager, aliases
      end

      # Action executed when machine up
      #
      #@param env [Hash] Enviroment
      def machine_up(env)
        require 'vagrant-hostmanager/provisioner'

        instance = VagrantPlugins::HostManager::HostsFile::Updater.new(machine.env, machine.provider_name)
        instance.update_guest machine
        instance.update_host
      end

      # Action executed when machine halting
      #
      #@param env [Hash] Enviroment
      def machine_halt(env)
        require 'vagrant-hostmanager/provisioner'

        instance = VagrantPlugins::HostManager::HostsFile::Updater.new(machine.env, machine.provider_name)
        instance.update_host
      end

      # Can be configured?
      #
      #@param config_file     [::Impressbox::Objects::ConfigFile] Loaded config file data
      #
      #@return [Boolean]
      def self.can_be_configured?(config_file)
        Vagrant.has_plugin? 'vagrant-hostmanager'
      end

      private

      # Does HostManager configuration
      #
      #@param hostmanager [Object] Part of current vagrant config for configuring HostManager
      #@param aliases     [Array]  Aliases for hostname
      def configure_hostmanager(hostmanager, aliases)
        hostmanager.enabled = true
        hostmanager.manage_host = true
        hostmanager.manage_guest = true
        hostmanager.ignore_private_ip = false
        hostmanager.include_offline = false
        hostmanager.aliases = aliases unless aliases.empty?
      end

      # Extracts hostname and aliases array from loaded config file
      #
      #@param cfg [::Impressbox::Objects::ConfigFile] Loaded config file data
      #
      #@return [Array]
      def extract_data(cfg)
        aliases = cfg.hostname.dup
        if aliases.is_a?(Array)
          hostname = aliases.shift
        else
          hostname = aliases.dup
          aliases = []
        end
        [hostname, aliases]
      end

    end

  end
end
