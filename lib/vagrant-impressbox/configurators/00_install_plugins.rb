module Impressbox
  module Configurators

    # Installs plugins
    class InstallPlugins < Impressbox::Abstract::Configurator

      # Install gem shortcut
      InstallGem = VagrantPlugins::CommandPlugin::Action::InstallGem

      # Global variable to see if it was checked
      @@checked = false

      # Initialize middleware
      #
      #@param machine [Vagrant::Machine]        Current machine
      #@param config [Impressbox::ConfigFile]   Loaded config
      def initialize(machine, config)
        super machine, config

        if check_plugins?
          check_plugins
          @@checked = true
        end
      end

      private

      # Do we need to check for plugins
      #
      #@return [Boolean]
      def check_plugins?
        !@@checked && (ARGV.include?('up') || ARGV.include?('provision'))
      end

      # Checks if plugins where installed
      def check_plugins
        @machine.ui.info I18n.t('plugins.checking')
        plugins = not_installed_list
        if plugins.length > 0
          plugins.each do |plugin_name|
            params = plugin_install_action_info(plugin_name)
            @machine.env.action_runner.run InstallGem, params
          end
        end
      end

      # gets current command line
      #
      #@return [String]
      def current_command_line
        cmd = ''
        if ENV.has_key?('BUNDLE_BIN_PATH')
          cmd = 'bundler exec '
        end
        cmd + 'vagrant ' + ARGV.join(' ')
      end

      # Makes not installed plugins list
      #
      #@return [Array]
      def not_installed_list
        real_plugins_names.select do |plugin_name|
          not Vagrant.has_plugin? plugin_name
        end
      end

      # Makes real plugin name array
      #
      #@return [Array]
      def real_plugins_names
        @config.plugins.map do |plugin_name|
          'vagrant-' + plugin_name
        end
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
