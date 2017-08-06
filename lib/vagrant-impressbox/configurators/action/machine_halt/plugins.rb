module Impressbox
  module Configurators
    module Action
      module MachineHalt
        # Updates hosts
        class Plugins < Impressbox::Abstract::ConfiguratorAction
          # This method is used to configure/run configurator
          #
          #@param app         [Object]                            App instance
          #@param env         [Hash]                              Current loaded environment data
          #@param config_file [::Impressbox::Objects::ConfigFile] Loaded config file data
          #@param machine     [::Vagrant::Machine]                Current machine
          def configure(app, env, config_file, machine)
            loader.each do |configurator|
              next unless configurator.can_be_configured?(config_file)
              write_description env[:ui], configurator
              configurator.halt @app, env, config_file, env[:machine]
            end
          end

          # This method is used for description
          #
          #@return [String]
          def description
            I18n.t('configuring.plugins')
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

          # Writes plugin description
          #
          #@param ui                  [Object]                                                  UI
          #@param configurator        [::Impressbox::Impressbox::Abstract::ConfiguratorPlugin]  Configurator
          def write_description(ui, configurator)
            return unless configurator.description
            ui.info "\t[" + configurator.vagrant_plugin_name + "] " + configurator.description
          end

          # Gets path for Impressbox actions for this Vagrant action
          #
          #@return [Array]
          def dir
            File.join __dir__,
                      '..',
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
end
