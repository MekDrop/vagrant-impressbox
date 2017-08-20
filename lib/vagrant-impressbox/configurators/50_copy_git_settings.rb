module Impressbox
  module Configurators

    # Copies git settings from host to guest
    class CopyGitSettings < Impressbox::Abstract::Configurator

      # Do provision tasks
      def provision
        if git_exist?
          @machine.ui.info I18n.t('copying.git_settings')
          update_remote_cfg local_cfg
        end
      end

      private

      # Git exists?
      #
      #@return [Boolean]
      def git_exist?
        system('git -v').nil?
      end

      # Returns host GIT config
      #
      #@return [Hash]
      def local_cfg
        ret = {}
        output = `git config --list --global`
        output.lines.each do |line|
          line.split(' ', 2) do |name, value|
            ret[name] = value
          end
        end
        ret
      end

      # Sets GIT settings on guest machine
      #
      #@param cfg     [Hash]                Git settings
      def update_remote_cfg(cfg)
        @machine.communicate.wait_for_ready 300

        cfg.each do |key, name|
          @machine.communicate "git config --global #{key} '#{name}'"
        end
      end
    end

  end
end
