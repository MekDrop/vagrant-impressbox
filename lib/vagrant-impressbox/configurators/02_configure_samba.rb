module Impressbox
  module Configurators

    # Configure samba
    class ConfigureSamba < Impressbox::Abstract::Configurator

      # Do configuration operations
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        if can_be_configured?
          map_sync_folder vagrant_config
        elsif provider_needs_samba?
          @machine.ui.error I18n.t('configuring.error.needs_samba')
          exit
        end
      end

      private

      # Is this provider needs samba?
      #
      # @return [Boolean]
      def provider_needs_samba?
        @machine.provider_name.to_s == 'hyperv'
      end

      # Can be configured?
      #
      # @return [Boolean]
      def can_be_configured?
        !@config.smb.empty? &&
          @config.smb.key?('ip') &&
          @config.smb.key?('user') &&
          @config.smb.key?('pass') &&
          !@config.smb['ip'].nil? &&
          !@config.smb['user'].nil? &&
          !@config.smb['pass'].nil? &&
          !@config.smb['ip'].empty? &&
          !@config.smb['user'].empty? &&
          !@config.smb['pass'].empty?
      end

      # Maps sync folder
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def map_sync_folder(vagrant_config)
        @machine.ui.info I18n.t('configuring.samba')
        puts @config.smb.inspect
        vagrant_config.vm.synced_folder '.', '/vagrant',
                                        id: 'vagrant',
                                        smb_host: @config.smb['ip'],
                                        smb_password: @config.smb['pass'],
                                        smb_username: @config.smb['user'],
                                        user: 'www-data',
                                        owner: 'www-data'
      end

    end
  end
end
