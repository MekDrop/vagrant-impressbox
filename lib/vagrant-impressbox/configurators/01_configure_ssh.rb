module Impressbox
  module Configurators

    # Configure ssh
    class ConfigureSsh < Impressbox::Abstract::Configurator

      # Do configuration operations
      #
      #@param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        @machine.ui.info I18n.t('configuring.ssh')
        vagrant_config.ssh.pty = false
        vagrant_config.ssh.forward_x11 = false
        vagrant_config.ssh.forward_agent = false
        if !@config.vars.nil? && @config.vars.is_a?(Array)
          vagrant_config.ssh.forward_env = @config.vars
        end
      end

    end
  end
end
