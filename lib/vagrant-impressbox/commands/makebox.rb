# Impressbox
module Impressbox
  module Commands
    # Command class
    class Makebox < Impressbox::Abstract::Command

      # Creates ConfigFile shortcut
      ConfigFile = Impressbox::Objects::ConfigFile

      # Creates Template shortcut
      Template = Impressbox::Objects::Template

      # Sets default values for instance vars
      def set_defaults_args
        config = ConfigFile.default

        @box = config.box
        @ip = config.ip
        @hostname = config.hostname
        @memory = config.memory
        @cpus = config.cpus
      end

      # Initializer
      #
      # @param argv  [Objects] Arguments
      # @param env   [Env]     Enviroment
      def initialize(argv, env)
        return if env.nil?

        super argv, env

        @box = "ImpressCMS/DevBox-Ubuntu"

        @cwd = env.cwd.to_s
        @template = Template.new
      end

      # If box option is suplied...
      #
      # @param box [String] Supplied value
      def on_box(box)
        @box = box
      end

      # If ip option is suplied...
      #
      # @param ip [String] Supplied value
      def _on_ip(ip)
        @ip = ip
      end

      # If hostname option is suplied...
      #
      # @param hostname [String] Supplied value
      def on_hostname(hostname)
        @hostname = hostname
      end

      # Execute command
      #
      # @return [Integer]
      def execute2
        unless @args.nil?
          write_result_msg do_prepare
        end
        0
      end

      private

      # Gets yaml file from current vagrantfile
      #
      # @return [String]
      def selected_yaml_file
        p = current_impressbox_provisioner
        if p.nil? || p.config.nil? || p.config.file.nil? ||
          !(p.config.file.is_a?(String) && p.config.file.chop.length > 0)
          return 'config.yaml'
        end
        p.config.file
      end

      # Gets current provisioner with impressbox type
      #
      # @return [::VagrantPlugins::Kernel_V2::VagrantConfigProvisioner,nil]
      def current_impressbox_provisioner
        @env.vagrantfile.config.vm.provisioners.each do |provisioner|
          next unless provisioner.type == :impressbox
          return provisioner
        end
        nil
      end

      # Prepares options array
      #
      # @param options [Hash]  Current options
      def update_latest_options(options)
        options[:info] = {
          last_update: Time.now.to_s,
          website_url: 'http://impresscms.org'
        }
        options[:file] = @file.dup
        update_name options
      end

      # Updates name param in options hash
      #
      # @param options [Hash]  Input/output hash
      def update_name(options)
        if options.key?(:name) && options[:name].is_a?(String) && options[:name].length > 0
          return
        end
        hostname = if options.key?(:hostname) then
                     options[:hostname]
                   else
                     @args.default_values[:hostname]
                   end
        hostname = hostname[0] if hostname.is_a?(Array)
        options[:name] = hostname.gsub(/[^A-Za-z0-9_-]/, '-')
      end

      # Writes message for action result
      #
      # @param result [Boolean]
      def write_result_msg(result)
        msg = if result then
                I18n.t 'config.recreated'
              else
                I18n.t 'config.updated'
              end
        @env.ui.info msg
      end

      # Runs prepare all actions
      def do_prepare
        quick_make_file @file, 'config.yaml'
        quick_make_file 'Vagrantfile', 'Vagrantfile'
        must_recreate
      end

      # Renders and safes file
      #
      # @param local_file [String] Local filename
      # @param tpl_file  [String] Template filename
      def quick_make_file(local_file, tpl_file)
        current_file = local_file(local_file)
        template_file = @template.real_path(tpl_file)
        @template.make_file(
          template_file,
          current_file,
          @args.all.dup,
          make_data_files_array(current_file),
          method(:update_latest_options)
        )
      end

      # Makes data files array
      #
      # @param current_file [String] Current file name
      #
      # @return [Array]
      def make_data_files_array(current_file)
        data_files = [
          ConfigData.real_path('default.yml')
        ]
        unless use_template_filename.nil?
          data_files.push use_template_filename
        end
        unless must_recreate
          data_files.push current_file
        end
        data_files
      end

      # Gets local file name with path
      #
      # @param file [String] File to append path
      #
      # @return [String]
      def local_file(file)
        File.join @cwd, file
      end

      # Returns template filename if specific template was specified (not default)
      #
      # @return [String,nil]
      def use_template_filename
        return nil unless @args[:___use_template___]
        ConfigData.real_type_filename 'templates', @args[:___use_template___]
      end

      # Must recreate config files ?
      #
      # @return [Boolean]
      def must_recreate
        @args[:___recreate___]
      end

    end
  end
end
