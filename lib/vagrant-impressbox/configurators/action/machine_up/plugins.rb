module Impressbox
  module Configurators
    module Action
      module MachineUp
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
              next unless configurator.can_be_configured?
              write_description env[:ui], configurator.description
              configurator.up @app, env, config_file, env[:machine]
            end
          end

          # This method is used for description
          #
          #@return [String]
          def description
            I18n.t('configuring.plugins')
          end

          private

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
          #@param ui          [Object]  UI
          #@param description [String]  Description
          def write_description(ui, description)
            return unless description
            ui.info "\t" + description
          end

        end
      end
    end
  end
end
