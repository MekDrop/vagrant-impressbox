module Impressbox
  module Configurators

    # Inserts keys into machine
    class InsertKey < Impressbox::Abstract::Configurator

      # SshKeyDetect shortcut
      SshKeyDetect = Impressbox::Objects::SshKeyDetect

      # Initialize middleware
      #
      #@param machine [Vagrant::Machine]        Current machine
      #@param config [Impressbox::ConfigFile]   Loaded config
      def initialize(machine, config)
        @keys = SshKeyDetect.new config

        super machine, config
      end

      # Do configuration operations
      #
      #@param vagrant_config [Hash]  Current Vagrantfile configuration instance
      def configure(vagrant_config)
        vagrant_config.ssh.private_key_path = [@keys.private_key] if @keys.private_key?
      end

      # Do provision tasks
      def provision
        machine_private_key if @keys.private_key?
        machine_public_key if @keys.public_key?
      end

      private

      # Updates public key
      def machine_public_key
        @machine.ui.info I18n.t('ssh_key.updating.public')
        return unless machine_upload_file @keys.public_key, '~/.ssh/id_rsa.pub'
        afile = '~/.ssh/authorized_keys'
        @machine.communicate.execute 'touch ' + afile
        @machine.communicate.execute 'cat ~/.ssh/id_rsa.pub >> ' + afile
        @machine.communicate.execute "echo `awk '!a[$0]++' " + afile + '` > ' + afile
        @machine.communicate.execute 'chmod 600 ~/.ssh/id_rsa.pub'
      end

      # Updates public key
      #
      #@param private_key   [String]                               Private key filename on host
      def machine_private_key
        ui.info I18n.t('ssh_key.updating.private')
        if machine_upload_file @keys.private_key, '~/.ssh/id_rsa'
          @machine.communicate.execute 'chmod 400 ~/.ssh/id_rsa'
        end
      end

      # Upload file to guest machine from host machine
      #
      #@param src_file      [String]                               Source file to upload
      #@param dst_file      [String]                               Destination filename to save
      def machine_upload_file(src_file, dst_file)
        prepare_guest_file dst_file
        write_lines_to_remote_file read_file_good(src_file), dst_file
        true
      end

      # Writes lines to remote file
      #
      #@param lines        [Array]                                Lines to write
      #@param file         [String]                               File where to write
      def write_lines_to_remote_file(lines, file)
        lines.each_line do |line|
          @machine.communicate.execute "echo \"#{line.rstrip}\" >> #{file}"
        end
      end

      # Reads specific file and replace all OS specific line-endings to Linux line-endings
      #
      #@param file  [String]  File to read
      #
      #@return [String]
      def read_file_good(file)
        text = File.open(file).read
        text.gsub!(/\r\n?/, "\n")
        text
      end

      # Execute some needed commands on specific file on guest machine
      #
      #@param file         [String]                               Filename to use in all operations in this method
      def prepare_guest_file(file)
        communicator.execute 'chmod 777 ' + file + ' || :'
        communicator.execute 'touch ' + file
        communicator.execute 'truncate -s 0 ' + file
      end

    end

  end
end
