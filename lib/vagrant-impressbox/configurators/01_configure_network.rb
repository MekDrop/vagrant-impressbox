module Impressbox
  module Configurators

    # Configure network
    class ConfigureNetwork < Impressbox::Abstract::Configurator

      # Do configuration operations
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        @machine.ui.info I18n.t('configuring.network')
        configure_private_network vagrant_config
        forward_ports(vagrant_config) unless @config.ports.nil?
      end

      private

      # Configure private network
      #
      # @param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure_private_network(vagrant_config)
        if @config.ip
          vagrant_config.vm.network 'private_network', ip: @config.ip
        else
          vagrant_config.vm.network 'private_network', type: 'dhcp'
        end
      end

      # Forward ports from hash
      #
      # @param vagrant_config [Object]  Current vagrant config
      def forward_ports(vagrant_config)
        @config.ports.each do |pgroup|
          vagrant_config.vm.network 'forwarded_port',
                                    guest: pgroup['guest'],
                                    host: pgroup['host'],
                                    protocol: extract_protocol(pgroup),
                                    auto_correct: true
        end
      end

      # Extracts protocol name from array port item
      #
      # @param pgroup [Hash] Ports array item
      #
      # @return [String]
      def extract_protocol(pgroup)
        possible = %w(tcp udp)
        return 'tcp' unless pgroup.key?('protocol')
        return 'tcp' unless possible.include?(pgroup['protocol'])
        pgroup['protocol']
      end

    end
  end
end
