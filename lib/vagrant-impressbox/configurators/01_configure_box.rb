module Impressbox
  module Configurators

    # Configure box
    class ConfigureBox < Impressbox::Abstract::Configurator

      # Do configuration operations
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        @machine.ui.info I18n.t('configuring.box')
        update_box_name(vagrant_config) if @config.name
        vagrant_config.vm.box_check_update = @config.check_update
      end

      private

      # Updates box name
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def update_box_name(vagrant_config)
        vagrant_config.vm.define @config.name.to_s
      end


    end
  end
end
