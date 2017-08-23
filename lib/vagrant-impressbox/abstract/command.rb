module Impressbox
  module Abstract
    # Abstract command class
    class Command < Vagrant.plugin('2', :command)

      # Creates CommandOptionsParser shortcut
      CommandOptionsParser = Impressbox::Objects::CommandOptionsParser

      # Gets command description
      #
      # @return [String]
      def self.synopsis
        class_name = to_s.split('::').last.downcase
        I18n.t "command.#{class_name}.synopsis"
      end

      # Initializer
      #
      # @param argv  [Objects] Arguments
      # @param env   [Env]     Enviroment
      def initialize(argv, env)
        super argv, env

        set_defaults_args
      end

      # Executes command
      #
      # @return [Integer]
      def execute
        argv = parse_options(options_parser)
        return unless argv
      end

      # Sets default values for instance vars
      def set_defaults_args;
      end

      # Gets footer
      #
      # @return [String]
      def footer;
      end

      # Gets banner
      #
      # @return [String]
      def banner
        I18n.t "command.#{class_name}.usage", cmd: "vagrant #{class_name}"
      end

      private

      # Gets classname
      #
      # @return [String]
      def class_name
        self.class.name.split('::').last.downcase
      end

      # Gets options parser
      #
      # @return [OptionParser]
      def options_parser
        OptionParser.new do |o|
          o.banner = banner
          o.separator ''
          o.separator I18n.t('command.default.possible_options')
          map_args_to_option_parser! o
          o.separator footer if footer
        end
      end

      # Maps args to option parser
      #
      # @param o [OptionParser] OptionParser
      def map_args_to_option_parser!(o)
        arguments_methods.each do |arg_info|
          params = make_map_params(arg_info)
          o.on(*params)
        end
      end

      # Makes map option args params
      #
      # @param arg_info [Hash] Argument info
      #
      # @return [Array]
      def make_map_params(arg_info)
        params = []
        params.push arg_info[:short_arg] unless arg_info[:short_arg].nil?
        params.push arg_info[:full_arg]
        params.push arg_info[:desc]
        caller = proc do |v|
          arg_info[:method].call v
        end
        params.push caller
        params
      end

      # Gets arguments methods
      #
      # @return Array
      def arguments_methods
        args = []
        methods.grep(/^_?on_/).map do |method_name|
          args.push make_argument_info(method_name)
        end
        args
      end

      # Makes arguments info from method name
      #
      # @param method_name [String] Method name
      #
      # @return [Hash]
      def make_argument_info(method_name)
        arg, short_arg = arg_and_short_arg_from_method(method_name)
        imethod = method(method_name)
        {
          method: imethod,
          full_arg: make_full_arg(arg, imethod),
          short_arg: short_arg,
          desc: desc_for_arg(arg)
        }
      end

      # Arg and arg short name from  method name
      #
      # @param method_name [Symbol|String] Method name
      #
      # @return [String,String|nil]
      def arg_and_short_arg_from_method(method_name)
        mname = method_name.to_s
        return [mname[4..-1], nil] if mname[0] == '_'
        arg = mname[3..-1]
        [
          arg,
          '-' + arg[0]
        ]
      end

      # Makes beatiful params
      #
      # @param arg    [String] Argument name
      # @param method [Method] Method for what to make params
      #
      # @return [String]
      def make_full_arg(arg, method)
        full_arg = '--' + arg
        full_arg += ' ' + make_beautiful_params(method)
        full_arg.strip
      end

      # Makes beautiful params
      #
      # @param method [Method] Method for what to make params
      #
      # @return [String]
      def make_beautiful_params(method)
        params = method.parameters.map do |param|
          param[1].upcase
        end
        params.join ' '
      end

      # Get description for argument
      #
      # @param arg [String] Argument name
      #
      # @return [Hash]
      def desc_for_arg(arg)
        desc_args = desc_data_for_arg(arg)
        iarg = '@' + arg
        if instance_variable_defined? iarg
          tmp_val = instance_variable_get(iarg)
          desc_args[:default_value] = tmp_val.nil? ? '(none)' : tmp_val
        end
        I18n.t "command.#{class_name}.arguments.#{arg}", desc_args
      end

      # Get description data for argument
      #
      # @param arg [String] Argument name
      #
      # @return [Hash]
      def desc_data_for_arg(arg)
        r = Regexp.new("^desc_data_#{arg}$")
        selected_methods = methods.grep(r)
        return {} unless selected_methods.length == 1
        method(selected_methods[0]).call
      end
    end
  end
end
