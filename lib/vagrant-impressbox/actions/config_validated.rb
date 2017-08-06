module Impressbox
  module Actions
    class ConfigValidated

      # Initializer
      #
      #@param app [Object]  App instance
      #@param env [Hash]    Current loaded environment data
      def initialize(app, env)
        @app = app
      end

      # Action is called
      #
      #@param env [Hash]   Current loaded environment data
      def call(env)
        config_file = ::Impressbox::Provisioner.loaded_config
        if config_file
          process env, env[:machine], config_file
        end

        @app.call(env)
      end

      private

      # Process machine Up actions
      #
      #@param env         [Hash]    Current loaded environment data
      #@param machine     [Hash]    Machine
      #@param config_file [Hash]    Config file
      def process(env, machine, config_file)
        loader.each do |configurator|
          next unless configurator.can_be_configured?(@app, env, config_file, machine)
          env[:ui].info configurator.description if configurator.description
          configurator.configure @app, env, config_file, machine
        end
      end

      # Gets preconfigured loader instance
      #
      #return [::Impressbox::Objects::MassFileLoader]
      def loader
        ::Impressbox::Objects::MassFileLoader.new(
          namespace,
          dir
        )
      end

      # Gets path for Impressbox actions for this Vagrant action
      #
      #@return [Array]
      def dir
        File.join __dir__,
                  '..',
                  'configurators',
                  'action',
                  'config_validated'
      end

      # Namespace used for all related Impressbox actions
      #
      #@return [String]
      def namespace
        'Impressbox::Configurators::Action::ConfigValidated'
      end

    end
  end
end
