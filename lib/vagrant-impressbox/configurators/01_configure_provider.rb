module Impressbox
  module Configurators

    # Configure provider
    class ConfigureProvider < Impressbox::Abstract::Configurator

      # Do configuration operations
      #
      #@param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        @machine.ui.info I18n.t('configuring.provider')
        call_method = provider_method_name
        if method_exists? call_method
          send call_method
        else
          @machine.ui.warn I18n.t('configuring.warning.configuring_provider_not_possible')
        end
      end

      private

      # Method exists?
      #
      #@param method_name [String] Method name
      #
      #@return [Boolean]
      def method_exists?(method_name)
        true if method(method_name) rescue false
      end

      # Gets provider method name
      #
      #@return [String]
      def provider_method_name
        'configure_' + @machine.provider_name.to_s
      end

      # Prints configuration is not possible for selected option
      #
      #@param what [String] Option name
      def configuration_is_not_possible(what)
        @machine.ui.warn I18n.t('configuring.warning.configuration_is_not_possible.' + what)
      end

      # Run virtualbox configuration
      def configure_virtualbox
        @machine.provider_config.gui = @config.gui
        @machine.provider_config.cpus = @config.cpus
        @machine.provider_config.memory = @config.memory
        @machine.provider_config.name = @config.name
      end

      # Run hyperv configuration
      def configure_hyperv
        @machine.provider_config.memory = @config.memory
        @machine.provider_config.maxmemory = @config.maxmemory
        @machine.provider_config.cpus = @config.cpus
        @machine.provider_config.vmname = @config.name
        configuration_is_not_possible('gui') if @config.gui
      end

      # Run docker configuration
      def configure_docker
        configuration_is_not_possible('gui') if @config.gui
        configuration_is_not_possible('memory') if @config.memory
        configuration_is_not_possible('cpus') if @config.cpus
        @machine.provider_config.vagrant_machine = @config.name
        @machine.provider_config.name = @config.name
      end

      # Configure vmware fusion
      def configure_vmware_fusion
        @machine.provider_config.gui = @config.gui
        @machine.provider_config.vmx["memsize"] = @config.memory.to_s
        @machine.provider_config.vmx["numvcpus"] = @config.cpus.to_s
        @machine.provider_config.vmx['displayname'] = @config.name
      end

      # Configure libvrt
      def configure_libvrt
        @machine.provider_config.memory = @config.gui
        @machine.provider_config.cpus = @config.cpus
        @machine.provider_config.cpu_mode = 'host-model'
        @machine.provider_config.graphics_type = @config.gui ? 'sdl' : 'none'
        configuration_is_not_possible('name') if @config.name
      end

      # Configure parallels
      def configure_parallels
        @machine.provider_config.update_guest_tools = true
        @machine.provider_config.customize ["set", :id, "--longer-battery-life", "off"]
        @machine.provider_config.memory = memory
        @machine.provider_config.cpus = cpus
        @machine.provider_config.name = name
      end

    end
  end
end
