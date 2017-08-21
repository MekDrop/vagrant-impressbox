module Impressbox
  module Configurators

    # Adds if is possible file notification support
    class FileNotificationsSupport < Impressbox::Abstract::Configurator

      # Do configuration operations
      #
      #@param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        if Vagrant.has_plugin?('vagrant-fsnotify')
          configure_fsnotify vagrant_config
        elsif Vagrant.has_plugin?('vagrant-notify-forwarder')
          configure_notify_forwarder vagrant_config
        end
      end

      private

      # Configure vagrant-fsnotify plugin
      #
      #@param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure_fsnotify(vagrant_config)
        vagrant_config.vm.synced_folder ".", "/vagrant", fsnotify: true
      end

      # Configure vagrant-notify-forwarder plugin
      #
      #@param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure_notify_forwarder(vagrant_config)
        vagrant_config.notify_forwarder.port = 29324
        vagrant_config.notify_forwarder.run_as_root = false
        vagrant_config.notify_forwarder.enable = true
      end

    end
  end
end
