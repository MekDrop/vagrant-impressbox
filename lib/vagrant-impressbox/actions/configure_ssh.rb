require_relative 'base_action'

module Impressbox
  module Actions
    # Configures default SSH configuration
    class ConfigureSSH < BaseAction
      private

      def description
        I18n.t 'configuring.ssh'
      end

      def configure(machine, config)
        # @config.ssh.insert_key = true
        machine.config.ssh.pty = false
        machine.config.ssh.forward_x11 = false
        machine.config.ssh.forward_agent = false
        unless config.vars.nil? && config.vars.is_a?(Array)
          machine.config.ssh.forward_env = config.vars
        end
      end
    end
  end
end