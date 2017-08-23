# Impressbox
module Impressbox
  module Commands
    # Command class
    class Makebox < Impressbox::Abstract::Command

      # Creates ConfigFile shortcut
      ConfigFile = Impressbox::Objects::ConfigFile

      # Creates Template shortcut
      Template = Impressbox::Objects::Template

      # DirInfo shortcut
      DirInfo = Impressbox::Objects::DirInfo

      # FileInfo shortcut
      FileInfo = Impressbox::Objects::FileInfo

      # Sets default values for instance vars
      def set_defaults_args
        config = ConfigFile.default

        @box = config.box
        @ip = config.ip
        @hostname = config.hostname
        @memory = config.memory
        @cpus = config.cpus
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
      def _on_hostname(hostname)
        @hostname = hostname
      end

      # If memory option is suplied...
      #
      # @param ram [String] Supplied value
      def _on_memory(ram)
        @memory = ram
      end

      # If cpus option is suplied...
      #
      # @param ram [String] Supplied value
      def _on_cpus(cpu_number)
        @cpus = cpu_number
      end

      # If recreate option is suplied...
      def on_recreate

      end

      # If template option is suplied...
      def on_template(name)

      end

      # Gets extra params for template desc
      #
      # @return [Hash]
      def desc_data_template
        path = File.join('data', 'predefined')
        templates = []
        DirInfo.create_from_source_path(path).each do |item|
          next unless item.kind_of? FileInfo
          templates.push item.short_name[0..-item.extension.length-1]
        end
        {
          templates: templates.join(', ')
        }
      end

    end
  end
end
