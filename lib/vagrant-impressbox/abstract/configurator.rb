module Impressbox
  module Abstract
    # Abstract middleware class
    class Configurator

      # Initialize middleware
      #
      # @param machine [Vagrant::Machine]        Current machine
      # @param config [Impressbox::ConfigFile]   Loaded config
      def initialize(machine, config)
        @machine = machine
        @config = config
      end

      # Cleanup operations
      def cleanup

      end

      # Do configuration operations
      #
      # @param root_config [Hash]  Current Vagrantfile configuration instance
      def configure(root_config)

      end

      # Do provision tasks
      def provision

      end

    end
  end
end
