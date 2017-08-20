# Impressbox namespace
module Impressbox
  # Objects namespace
  module Objects
    # File info reader
    class FileInfo

      # Filename
      #
      #@return [String]
      attr_reader :filename

      # Last instance (if there where any)
      #
      #@return [Object]
      attr_reader :last_instance

      # Base path
      BASE_PATH = File.expand_path('..', __dir__).freeze

      # StringTools shortcut
      StringTools = ::Impressbox::Objects::StringTools

      # Initializer
      #
      #@param filename [String] Filename
      def initialize(filename)
        @filename = filename
      end

      # Is Ruby file?
      #
      #@return [Boolean]
      def ruby_file?
        extension == '.rb'
      end

      # Gets relative path
      #
      #@return [String]
      def relative_path
        @filename.sub BASE_PATH, ''
      end

      # Gets short filename
      #
      #@return [String]
      def short_name
        File.basename @filename
      end

      # Gets extension
      #
      #@return [String]
      def extension
        File.extname @filename
      end

      # Gets namespace for file
      #
      #@return [String]
      def namespace
        namespace_parts.join('::')
      end

      # Gets namespace parts array
      #
      #@return [Array]
      def namespace_parts
        t_str=StringTools.remove_at_end(relative_path, short_name)
        t_str.split(/[\\]|[\/]/).map do |part|
          StringTools.concat_capitalize part.split('_')
        end.reject do |part|
          part.empty?
        end
      end

      # Gets class name for file
      #
      #@return [String]
      def class_name
        StringTools.concat_capitalize class_name_parts
      end

      # Gets class name for file parts array
      #
      #@return [Array]
      def class_name_parts
        parts = File.basename(@filename, extension).split('_')
        parts.delete_at(0) if StringTools.is_numeric(parts[0])
        parts
      end

      # Gets classname with namespace
      #
      #@return [String]
      def full_class_name
        full_class_name_parts.join '::'
      end

      # Gets classname with namespace parts
      #
      #@return [Array]
      def full_class_name_parts
        ['Impressbox'] + namespace_parts + [class_name]
      end

      # Gets const class name
      #
      #@return [Object]
      def const_class_name
        require @filename
        full_class_name_parts.inject(Object) do |o, c|
          o.const_get c
        end
      end

      # Gets instance of class
      #
      #@param args [Array] Args array
      #
      #@return [Object]
      def instance(*args)
        @last_instance = const_class_name.new(*args)
      end

    end
  end
end
