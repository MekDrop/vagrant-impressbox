module Impressbox
  module Abstract
    # This is a base to use for other plugin configurators
    class ConfiguratorPlugin

      # Do configuration tasks
      #
      #@param vagrant_config  [Object]                            Current vagrant config
      #@param config_file     [::Impressbox::Objects::ConfigFile] Loaded config file data
      def configure(vagrant_config, config_file)
        raise I18n.t('configuring.error.must_overwrite')
      end

      # This method is used for description
      #
      #@return [String]
      def description
      end

      # Gets vagrant plugin name
      #
      #@return [String]
      def vagrant_plugin_name
        'vagrant-' + short_name
      end

      # Gets short class name
      #
      #@return [String]
      def short_name
        self.class.name.to_s.split('::').last.downcase
      end

      # Can be executed ?
      #
      #@param config_file     [::Impressbox::Objects::ConfigFile] Loaded config file data
      #
      #@return            [Boolean]
      def can_be_configured?(config_file)
        Vagrant.has_plugin?(vagrant_plugin_name) or config_file.plugins.include?(short_name)
      end

      # This method is used to configure/run configurator on halt
      #
      #@param app         [Object]                            App instance
      #@param env         [Hash]                              Current loaded environment data
      #@param config_file [::Impressbox::Objects::ConfigFile] Loaded config file data
      #@param machine     [::Vagrant::Machine]                Current machine
      def halt(app, env, config_file, machine)
      end

      # This method is used to configure/run configurator on up
      #
      #@param app         [Object]                            App instance
      #@param env         [Hash]                              Current loaded environment data
      #@param config_file [::Impressbox::Objects::ConfigFile] Loaded config file data
      #@param machine     [::Vagrant::Machine]                Current machine
      def up(app, env, config_file, machine)
      end

    end
  end
end
