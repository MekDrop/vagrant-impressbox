module Impressbox
  module Configurators

    # Run shell script
    class RunShell < Impressbox::Abstract::Configurator

      # Do provision tasks
      def provision
        if can_be_configured?
          @machine.ui.info I18n.t('configuring.provision')

          host_file = make_tmp_file(@config.provision)
          guest_file = '/tmp/' + File.basename(host_file)
          exec_on_machine 'rm -rf ' + guest_file
          @machine.communicate.upload host_file, guest_file
          exec_on_machine 'bash ' + guest_file
          exec_on_machine 'rm -rf ' + guest_file
        end
      end

      private

      # Can be executed ?
      #
      # @return            [Boolean]
      def can_be_configured?
        p = @config.provision
        p.is_a?(String) && p.strip.length > 0
      end

      private

      # Makes temp file from commands and return filename
      #
      # @param commands [String] Commmands to save
      #
      # @return [String]
      def make_tmp_file(commands)
        require 'tempfile'
        file = Tempfile.new('impressbox-run_shell', {
          :encoding => 'UTF-8',
          :textmode => true,
          :autoclose => false,
          :universal_newline => true
        })
        tpl = Template.new
        contents = commands.gsub(/\r\n?/, "\n")
        path = file.path
        file.write tpl.render_string(contents)
        file.close
        path
      end

      # Execute command on machine
      #
      # @param cmd      [String]
      def exec_on_machine(cmd)
        @machine.communicate.execute(cmd) do |type, data|
          write_output type, data
        end
      end

      # Gets line color by output type
      #
      # @param type [Symbol] Result type
      #
      # @return [Symbol]
      def line_color(type)
        return :green if type == :stdout
        :red
      end

      # Writes output to console
      #
      # @param type     [Symbol]               Output type
      # @param data     [String]               Output data
      def write_output(type, data)
        data = data.chomp
        return unless data.length > 0

        @machine.ui.info data, :color => line_color(type)
      end

    end
  end
end
