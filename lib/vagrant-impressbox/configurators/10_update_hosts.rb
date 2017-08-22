module Impressbox
  module Configurators

    # Updates hosts
    class UpdateHosts < Impressbox::Abstract::Configurator

      # Initialize middleware
      #
      # @param machine [Vagrant::Machine]        Current machine
      # @param config [Impressbox::ConfigFile]   Loaded config
      def initialize(machine, config)
        @aliases = config.hostname.dup
        if @aliases.is_a?(Array)
          @hostname = @aliases.shift
        else
          @hostname = @aliases.dup
          @aliases = []
        end

        super machine, config
      end

      # Do configuration operations
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        vagrant_config.vm.hostname = @hostname unless @hostname.empty?
        if Vagrant.has_plugin?('vagrant-hostmanager')
          configure_hostmanager vagrant_config
        elsif Vagrant.has_plugin?('vagrant-hostsupdater')
          configure_hostsupdater vagrant_config
        end
      end

      private

      # Configure hostmanager plugin
      #
      # # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure_hostmanager(vagrant_config)
        vagrant_config.hostmanager.enabled = true
        vagrant_config.hostmanager.manage_host = true
        vagrant_config.hostmanager.manage_guest = true
        vagrant_config.hostmanager.ignore_private_ip = false
        vagrant_config.hostmanager.include_offline = false
        vagrant_config.hostmanager.aliases = @aliases unless @aliases.empty?
      end

      # Configure hostsupdater plugin
      #
      # # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure_hostsupdater(vagrant_config)
        vagrant_config.hostsupdater.aliases = @aliases unless @aliases.empty?
        vagrant_config.hostsupdater.remove_on_suspend = true
      end

    end
  end
end
