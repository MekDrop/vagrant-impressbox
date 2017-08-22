require 'vagrant'
require 'yaml'
require_relative 'config_data'

# Impressbox namespace
module Impressbox
  # Objects namepsace
  module Objects
    # Config reader
    class ConfigFile

      # Environment vars collection
      #
      # @!attribute [rw] vars
      #
      # @return [Hash]
      attr_reader :vars

      # Samba configuration
      #
      # @!attribute [rw] smb
      #
      # @return [Hash]
      attr_reader :smb

      # SSH keys filenames
      #
      # @!attribute [rw] keys
      #
      # @return [Hash]
      attr_reader :keys

      # Ports bidning between host and guest
      #
      # @!attribute [rw] ports
      #
      # @return [Array]
      attr_reader :ports

      # Check box for update?
      #
      # @!attribute [rw] check_update
      #
      # @return [Boolean]
      attr_reader :check_update

      # How many CPUs to use for box?
      #
      # @!attribute [rw] cpus
      #
      # @return [Integer]
      attr_reader :cpus

      # How much memory (in megabytes) to use for virtual box?
      #
      # @!attribute [rw] memory
      #
      # @return [Integer]
      attr_reader :memory

      # Show GUI?
      #
      # @!attribute [rw] gui
      #
      # @return [Boolean]
      attr_reader :gui

      # Defines shell provision commands
      #
      # @!attribute [rw] provision
      #
      # @return [String]
      attr_reader :provision

      # Box name
      #
      # @!attribute [rw] name
      #
      # @return [String]
      attr_reader :name

      # Binded IP
      #
      # @!attribute [rw] ip
      #
      # @return [Hash]
      attr_reader :ip

      # Binded hostname(s)
      #
      # @!attribute [rw] hostname
      #
      # @return [String,Array]
      attr_reader :hostname

      # Plugins
      #
      # @!attribute [rw] plugins
      #
      # @return [String,Array]
      attr_reader :plugins

      # Box
      #
      # @!attribute [rw] box
      #
      # @return [String]
      attr_reader :box

      # Default config
      #
      # @return [self]
      def self.default
        file = File.join(
          __dir__,
          '..',
          'configs',
          'default.yml'
        )
        self.new file
      end

      # Constructor / Initializer
      def initialize(file)
        load_yaml(file).each do |key, value|
          puts key
          if self.respond_to?(key + '=')
            send key + "=", value
          end
        end
      end

      # Sets 'vars' variable
      #
      # @param value [Object]  Value to set to variable
      def vars=(value)
        if value.kind_of?(Array)
          @vars = value
        elsif value.nil?
          @vars = []
        else
          raise_assign_error 'vars', value
        end
      end

      # Sets 'smb' variable
      #
      # @param value [Object]  Value to set to variable
      def smb=(value)
        if value.kind_of?(Hash)
          @vars = {
            :ip => value.key?('ip') ? value[:ip] : nil,
            :user => value.key?('user') ? value[:user] : nil,
            :pass => value.key?('pass') ? value[:pass] : nil,
          }
        elsif value.nil?
          @vars = {
            :ip => nil,
            :user => nil,
            :pass => nil,
          }
        else
          raise_assign_error 'smb', value
        end
      end

      # Sets 'keys' variable
      #
      # @param value [Object]  Value to set to variable
      def keys=(value)
        if value.kind_of?(Hash)
          @keys = {
            :private => value[:private],
            :public => value[:public]
          }
        elsif value.nil?
          @vars = {
            :private => nil,
            :public => nil,
          }
        else
          raise_assign_error 'keys', value
        end
      end

      # Sets 'ports' variable
      #
      # @param value [Object]  Value to set to variable
      def ports=(value)
        if value.kind_of?(Array)
          @ports = value
        elsif value.nil?
          @ports = false
        else
          raise_assign_error 'ports', value
        end
      end

      # Sets 'check_update' variable
      #
      # @param value [Object]  Value to set to variable
      def check_update=(value)
        if value.kind_of?(Boolean)
          @check_update= value
        elsif value.nil?
          @check_update= false
        else
          raise_assign_error 'check_update', value
        end
      end

      # Sets 'cpus' variable
      #
      # @param value [Object]  Value to set to variable
      def cpus=(value)
        if value.kind_of?(Numeric)
          @cpus = value.to_int
        elsif value.nil?
          @cpus = 1
        else
          raise_assign_error 'cpus', value
        end
      end

      # Sets 'memory' variable
      #
      # @param value [Object]  Value to set to variable
      def memory=(value)
        if value.kind_of?(Numeric)
          @memory = value.to_int
        elsif value.nil?
          @memory = 1024
        else
          raise_assign_error 'memory', value
        end
      end

      # Sets 'gui' variable
      #
      # @param value [Object]  Value to set to variable
      def gui=(value)
        if value.kind_of?(Boolean)
          @gui= value
        elsif value.nil?
          @gui= false
        else
          raise_assign_error 'gui', value
        end
      end

      # Sets 'provision' variable
      #
      # @param value [Object]  Value to set to variable
      def provision=(value)
        if value.kind_of?(String)
          @provision = value
        elsif value.nil?
          @provision= ''
        else
          raise_assign_error 'provision', value
        end
      end

      # Sets 'name' variable
      #
      # @param value [Object]  Value to set to variable
      def name=(value)
        if value.kind_of?(String)
          @name = value
        elsif value.nil?
          @name= [*('a'..'z'), *('0'..'9')].shuffle[0, 8].join
        else
          raise_assign_error 'name', value
        end
      end

      # Sets 'ip' variable
      #
      # @param value [Object]  Value to set to variable
      def ip=(value)
        if value.kind_of?(String)
          @ip = value
        elsif value.nil?
          @ip= nil
        else
          raise_assign_error 'ip', value
        end
      end

      # Sets 'hostname' variable
      #
      # @param value [Object]  Value to set to variable
      def hostname=(value)
        if value.kind_of?(String)
          @hostname = value
        elsif value.nil?
          @hostname= nil
        else
          raise_assign_error 'hostname', value
        end
      end

      # Sets 'plugins' variable
      #
      # @param value [Object]  Value to set to variable
      def plugins=(value)
        if value.kind_of?(Array)
          @plugins = value
        elsif value.nil?
          @plugins = []
        else
          raise_assign_error 'plugins', value
        end
      end

      # Sets 'box' variable
      #
      # @param value [Object]  Value to set to variable
      def box=(value)
        if value.kind_of?(String)
          @box = value
        elsif value.nil?
          @box= nil
        else
          raise_assign_error 'hostname', value
        end
      end

      # Converts config data to Hash
      #
      # @return [Hash]
      def to_hash
        instance_variables
      end

      private

      # Load Yaml file and returns contents
      #
      # @param file [String] File to load
      #
      # @return [Object]
      def load_yaml(file)
        @file = file
        YAML.load File.open(file)
      end

      # Raises assign var error
      #
      # @param var [String] Var name
      # @param value [Object] Value
      def raise_assign_error(var, value)
        params = {
          var: var,
          file: @file,
          value: value.inspect,
          type: value.class
        }
        raise I18n.t('template.error.bad_value_specified', params)
      end

    end
  end
end
