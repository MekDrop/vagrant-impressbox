module Impressbox
  module Configurators
    module Action
      module MachineUp
        # Updates hosts
        class InstallPlugins < Impressbox::Abstract::ConfiguratorAction

          # This method is used to configure/run configurator
          #
          #@param app         [Object]                            App instance
          #@param env         [Hash]                              Current loaded environment data
          #@param config_file [::Impressbox::Objects::ConfigFile] Loaded config file data
          #@param machine     [::Vagrant::Machine]                Current machine
          def configure(app, env, config_file, machine)
            config_file.plugins.each do |plugin_name|
              real_name = 'vagrant-' + plugin_name
              next if Vagrant.has_plugin? real_name
              error = try_install_plugin(app, env, real_name)
              if error
                env[:ui].error error.to_s
              end
            end
          end

          # This method is used for description
          #
          #@return [String]
          def description
            I18n.t('plugins.checking_instalation')
          end

          private

          # Try to install plugin
          #
          #@param app          [Object]  App instance
          #@param env          [Hash]    Enviroment
          #@param plugin_name  [Array]   Plugin name
          #
          #@param [StandardError]
          def try_install_plugin(app, env, plugin_name)
            env_data = env.merge(plugin_install_action_info(plugin_name))
            installer = VagrantPlugins::CommandPlugin::Action::InstallGem.new(app, {})
            last_exception = nil
            1.upto(3) do |failed_times|
              begin
                installer.call env_data
                return nil
              rescue => e
                last_exception = e
                sleep 1
              end
            end
            installer.recover env
            last_exception
          end

          # Makes install plugin action info
          #
          #@param plugin_name [String]  Plugin name
          #
          #@return [Hash]
          def plugin_install_action_info(plugin_name)
            {
              plugin_entry_point: nil,
              plugin_version: nil,
              plugin_sources: Vagrant::Bundler::DEFAULT_GEM_SOURCES.dup,
              plugin_name: plugin_name,
              plugin_verbose: false
            }
          end

        end
      end
    end
  end
end
