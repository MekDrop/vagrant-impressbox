module Impressbox
  module Configurators
    module Primary
      # Configures default SSH configuration
      class ConfigurePlugins < Impressbox::Abstract::ConfiguratorPrimary

        # Returns description
        #
        #@return [String]
        def description
          I18n.t('configuring.plugins')
        end

        # Do configuration tasks
        #
        #@param vagrant_config  [Object]                            Current vagrant config
        #@param config_file     [::Impressbox::Objects::ConfigFile] Loaded config file data
        #@param ui              [Object]                            Vagrant ui
        def configure(vagrant_config, config_file, ui)
          loader.each do |configurator|
            next unless configurator.can_be_configured?(config_file)
            ui.info "\t[" + configurator.vagrant_plugin_name + "] " + configurator.description
            configurator.configure vagrant_config, config_file
          end
        end

        private

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
                    'plugins'
        end

        # Namespace used for all related Impressbox actions
        #
        #return [String]
        def namespace
          'Impressbox::Configurators::Plugins'
        end


      end
    end
  end
end
